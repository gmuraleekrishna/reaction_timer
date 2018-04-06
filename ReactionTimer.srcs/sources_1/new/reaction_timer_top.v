`timescale 1ns / 1ps

module reaction_timer_top (
    input enable,
    input response_btn,
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
    parameter PREPARATION = 3'd0; 
    parameter TRIGGER = 3'd1;
    parameter COUNT = 3'd2;
    parameter WAIT_FOR_RESPONSE = 3'd3;
    parameter SHOW_TIME = 3'd4;

    parameter ON = 1;
    parameter OFF = 0;

    reg run_reaction_timer;
    wire [32:0] reaction_timer_count;
    reg [32:0] random_prep_time;
    reg run_prep_timer;
    wire [1:0] prep_timer_count;
    wire [32:0] random_number;
    reg [1:0] next_state;
    reg [32:0] display_value;
    wire db_response_btn;
    wire clk_1kHz;

    debouncer DEBOUNCE_RESPONSE_BTN (
        .clk(clk),
        .button_in(response_btn),
        .button_out(db_response_btn)
        );
    
    counter REACTION_COUNTER (
        .run(run_reaction_timer),
        .count(reaction_timer_count),
        .reset(reset),
        .enable(enable),
        .clk(clk)
        );
    
    
    clock_divider #(
        .THRESHOLD(5_000_000)
    ) CLOCK_1kHZ_GENERATOR (
        .clk(clk),
        .reset(1'b0),
        .enable(1'b1),
        .divided_clk(clk_1kHz)
        );

    counter_rev PREPERATION_COUNTER (
        .run(run_prep_timer),
        .count(prep_timer_count),
        .reset(reset),
        .enable(enable),
        .clk(clk_1kHz)
        );

    display DISPLAY_RESPONSE_TIME (
        .clk(clk),
        .value(display_value),
        .prep_timer_count_value(prep_timer_count),
        .reset(reset),
        .ssd_cathode(ssd_cathode),
        .ssd_anode(ssd_anode)
        );

    lfsr RAND_NUM_GEN (
        .random_number(random_number),
        .reset(reset),
        .clk(clk)
        );

    // divide the reaction time by 10^9, 10^8, 10^8 to extract the digits for seconds and micro seconds
    // send it to each SSDs
    // done

    always @(posedge clk) begin
        if (reset) begin
            next_state <= PREPARATION;
            
            run_reaction_timer <= OFF;
            trigger_led <= OFF;
            run_prep_timer <= ON;
        end else if (enable) begin
            case (next_state)
               PREPARATION: begin
                    if (enable) begin
                        trigger_led <= OFF;
                        run_prep_timer <= ON;
                        next_state  <=   TRIGGER;                 
                    end               
               end 
               TRIGGER: begin
                    random_prep_time <= random_number;
                    if(prep_timer_count == random_prep_time) begin
                        run_prep_timer <= OFF;
                        trigger_led <= ON;
                        next_state <= COUNT;
                    end
                end
                COUNT: begin 
                    run_reaction_timer <= ON; 
                    next_state <= WAIT_FOR_RESPONSE;
                end
                WAIT_FOR_RESPONSE: begin
                    display_value <= reaction_timer_count;
                    if (db_response_btn == ON | reaction_timer_count >= 33'd999_900_000) begin
                        run_reaction_timer <= OFF;
                        next_state <= SHOW_TIME;
                        trigger_led <= OFF;
                    end
                end
                SHOW_TIME:
                    display_value <= reaction_timer_count;   
                default:
                    next_state <= TRIGGER;
            endcase
        end
    end
endmodule
