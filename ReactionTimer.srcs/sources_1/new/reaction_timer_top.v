`timescale 1ns / 1ps

module reaction_timer_top (
    input enable,
    input response_btn,
    input ready_btn,
    input restart_btn,
    input reset,
    input clk,
    output reg trigger_led,
    output wire [7:0] ssd_cathode,
    output wire [3:0] ssd_anode
    );
    
    parameter IDLE = 3'd0;
    parameter PREPARATION = 3'd1; 
    parameter TRIGGER = 3'd2;
    parameter WAIT_FOR_RESPONSE = 3'd3;
    parameter SHOW_TIME = 3'd4;
    parameter FAILED = 3'd5;

    parameter FIVE_SECONDS = 14'd5_000; // for 1KHz clk
    parameter NINE_POINT_999_SECONDS = 14'd9_999;

    parameter ON = 1;
    parameter OFF = 0;

    parameter FLOAT = 2'd0;
    parameter DIGIT = 2'd1;
    parameter STRING = 2'd2;

    reg run_reaction_timer;
    reg reset_counters;
    reg enable_counters;
    wire [13:0] reaction_timer_count;
    reg [13:0] random_prep_time;
    reg [13:0] random_trigger_time;
    reg run_prep_timer;
    wire [13:0] preparation_count;
    wire [13:0] random_number;
    reg [2:0] next_state;
    reg [13:0] display_value;
    wire db_response_btn;
    wire db_restart_btn;
    wire clk_1kHz;
    wire clk_1Hz;
    wire [13:0] trigger_timer_count;
    reg run_trigger_timer;
    reg [1:0] display_data_type;

    reg best_reaction_time;
    reg clear_display;

    debouncer DEBOUNCE_RESPONSE_BTN (
        .clk(clk),
        .button_in(response_btn),
        .button_out(db_response_btn)
        );

    debouncer DEBOUNCE_READY_BTN (
        .clk(clk),
        .button_in(ready_btn),
        .button_out(db_ready_btn)
        );

    debouncer DEBOUNCE_RESTRT_BTN (
        .clk(clk),
        .button_in(restart_btn),
        .button_out(db_restart_btn)
        );
    
    clock_divider #(
        .THRESHOLD(50_000)
    ) CLOCK_1kHZ_GENERATOR (
        .clk(clk),
        .reset(1'b0),
        .enable(1'b1),
        .divided_clk(clk_1kHz)
        );

    counter REACTION_COUNTER (
        .run(run_reaction_timer),
        .count(reaction_timer_count),
        .reset(reset_counters),
        .enable(enable_counters),
        .clk(clk_1kHz)
        );

    clock_divider #(
        .THRESHOLD(50_000_000)
    ) CLOCK_1HZ_GENERATOR (
        .clk(clk),
        .reset(1'b0),
        .enable(1'b1),
        .divided_clk(clk_1Hz)
        );

    counter TRIGGER_COUNTER (
        .run(run_trigger_timer),
        .count(trigger_timer_count),
        .reset(reset_counters),
        .enable(enable_counters),
        .clk(clk_1kHz)
        );

    reverse_counter PREPARATION_COUNTER (
        .clk(clk_1Hz),
        .enable(enable_counters),
        .run(run_prep_timer),
        .reset(reset_counters),
        .count(preparation_count)
        ); 

    display DISPLAY (
        .clk(clk_1kHz),
        .value(display_value),
        .type(display_data_type),       
        .ssd_cathode(ssd_cathode),
        .ssd_anode(ssd_anode),
        .clear(clear_display)
        );

    lfsr RAND_NUM_GEN (
        .random_number(random_number),
        .reset(reset)
        .clk(clk)
        );

    always @(posedge clk) begin
        if (reset | db_restart_btn) begin
            next_state <= IDLE;
        end else if (enable) begin
            case (next_state)
                IDLE: begin
                    clear_display <= ON;
                    run_prep_timer <= OFF;
                    run_reaction_timer <= OFF;
                    trigger_led <= OFF;
                    run_trigger_timer <= OFF;
                    reset_counters <= ON;
                    enable_counters <= OFF;
                    if (db_ready_btn == ON) begin
                        next_state <= PREPARATION;
                    end     
                end
                PREPARATION: begin
                    clear_display <= OFF;
                    reset_counters <= OFF;
                    enable_counters <= ON;
                    trigger_led <= OFF;               
                    run_prep_timer <= ON;
                    display_data_type <= DIGIT;
                    display_value <= preparation_count;
                    if (preparation_count == 0) begin
                        next_state  <= TRIGGER;
                        run_prep_timer <= OFF; 
                        random_trigger_time <= random_number;                 
                    end 
                end 
                TRIGGER: begin
                    clear_display <= ON;
                    run_trigger_timer <= ON;
                    if(db_response_btn == ON) begin
                        run_trigger_timer <= OFF;
                        next_state <= FAILED;
                    end else if(trigger_timer_count == random_trigger_time | trigger_timer_count >= FIVE_SECONDS) begin
                        run_trigger_timer <= OFF;
                        trigger_led <= ON;
                        next_state <= WAIT_FOR_RESPONSE;
                    end
                end
                WAIT_FOR_RESPONSE: begin
                    run_reaction_timer <= ON; 
                    if (db_response_btn == ON) begin
                        run_reaction_timer <= OFF;
                        next_state <= SHOW_TIME;
                        trigger_led <= OFF;
                    end else if (reaction_timer_count >= NINE_POINT_999_SECONDS) begin
                        run_reaction_timer <= OFF;
                        trigger_led <= OFF;
                        next_state <= FAILED;
                    end
                end
                SHOW_TIME: begin
                    clear_display <= OFF;
                    display_data_type <= FLOAT;
                    display_value <= reaction_timer_count;
                    next_state <= IDLE;
                end 
                FAILED: begin
                    clear_display <= OFF;
                    display_value <= 14'd1; // FAIL
                    display_data_type <= STRING;
                    next_state <= IDLE;
                end
                default:
                    next_state <= IDLE;
            endcase
        end
    end
endmodule
