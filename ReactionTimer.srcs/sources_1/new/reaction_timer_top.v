`timescale 1ns / 1ps

module reaction_timer_top (
    input enable,
    input response_btn,
    input start_btn,
    input reset,
    input clk,
    output reg trigger_led,
    output wire [7:0] ssd_cathode,
    output wire [3:0] ssd_anode
    );
    
    // 1 glow led
    // 2 start timer
    // 3 timer count up
    // 4  if not trigger-ed go to 3
    // 5 stop timer
    // 6 get time 
    // 7 display time
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

    reg run_reaction_timer;
    reg reset_counters;
    reg enable_counters;
    wire [13:0] reaction_timer_count;
    reg [13:0] random_prep_time;
    reg [13:0] random_trigger_time;
    reg run_prep_timer;
    wire [13:0] preparation_count;
    wire [13:0] random_number;
    reg [1:0] next_state;
    reg [13:0] display_value;
    wire db_response_btn;
    wire clk_1kHz;
    wire clk_1Hz;
    wire [13:0] trigger_timer_count;
    reg run_trigger_timer;
    reg is_float;

    debouncer DEBOUNCE_RESPONSE_BTN (
        .clk(clk),
        .button_in(response_btn),
        .button_out(db_response_btn)
        );

    debouncer DEBOUNCE_START_BTN (
        .clk(clk),
        .button_in(start_btn),
        .button_out(db_start_btn)
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

    counter_rev PREPARATION_COUNT_DOWN (
        .clk(clk_1Hz),
        .enable(enable_counters),
        .run(run_prep_timer),
        .reset(reset_counters),
        .count(preparation_count)
        ); 

    display DISPLAY_RESPONSE_TIME (
        .clk(clk),
        .value(display_value),
        .is_float(is_float),       
        .ssd_cathode(ssd_cathode),
        .ssd_anode(ssd_anode)
        );

    lfsr RAND_NUM_GEN (
        .random_number(random_number),
        .reset(reset),
        .clk(clk)
        );

    always @(posedge clk) begin
        if (reset) begin
            next_state <= IDLE;
        end else if (enable) begin
            case (next_state)
                IDLE: begin
                    if (db_start_btn == ON) begin
                        next_state <= PREPARATION;
                    end
                    run_prep_timer <= OFF;
                    run_reaction_timer <= OFF;
                    trigger_led <= OFF;
                    run_trigger_timer <= OFF;
                    reset_counters <= ON;
                    enable_counters <= OFF;          
                end
                PREPARATION: begin
                    reset_counters <= OFF;
                    enable_counters <= ON;
                    trigger_led <= OFF;               
                    run_prep_timer <= ON;
                    is_float <= OFF;
                    display_value <= preparation_count;
                    if (preparation_count == 0) begin
                        next_state  <= TRIGGER;
                        run_prep_timer <= OFF; 
                        random_trigger_time <= random_number;                 
                    end 
                end 
                TRIGGER: begin
                    run_trigger_timer <= ON;
                    if(db_response_btn == ON) begin
                        run_trigger_timer <= OFF;
                        next_state <= FAILED;
                    end
                    
                    if(trigger_timer_count == random_trigger_time | trigger_timer_count >= FIVE_SECONDS ) begin
                        run_trigger_timer <= OFF;
                        trigger_led <= ON;
                        next_state <= WAIT_FOR_RESPONSE;
                    end
                end
                WAIT_FOR_RESPONSE: begin
                    run_reaction_timer <= ON; 
                    display_value <= reaction_timer_count;
                    is_float <= ON;
                    if (db_response_btn == ON | reaction_timer_count >= NINE_POINT_999_SECONDS) begin
                        run_reaction_timer <= OFF;
                        next_state <= SHOW_TIME;
                        trigger_led <= OFF;
                    end
                end
                SHOW_TIME: begin
                    display_value <= reaction_timer_count; 
                    is_float <= ON;
                end 
                FAILED: begin
                    next_state <= IDLE; //TBD: display "FAIL" in the SSD
                end
                default:
                    next_state <= IDLE;
            endcase
        end
    end
endmodule
