`timescale 1ns / 1ps

module game_fsm (
    input clk,
    input enable,
    input reset,
    input restart,
    input ready,
    input response,
    input [13:0] trigger_timer_count, //
    input [13:0] reaction_timer_count, //
    input [13:0] delay_timer_count,
    input [13:0] preparation_timer_count,
    input [13:0] random_number,
    input [13:0] reset_timer_count,
    output reg clear_display,
    output reg run_delay_timer,
    output reg run_prep_timer,
    output reg run_trigger_timer,
    output reg reset_counters,
    output reg run_reaction_timer,
    output reg enable_counters,
    output reg run_reset_timer,
    output reg [7:0] trigger_leds,
    output reg [1:0] display_data_type, //
    output reg [13:0] display_value, //
    );

    parameter IDLE = 3'd0; // states 
    parameter PREPARATION = 3'd1; 
    parameter TRIGGER = 3'd2;
    parameter WAIT_FOR_RESPONSE = 3'd3;
    parameter SHOW_TIME = 3'd4;
    parameter FAILED = 3'd5;
    parameter PARKING = 3'd6;

    parameter FIVE_SECONDS = 14'd5_000; // seconds
    parameter SEVEN_SECONDS = 14'd7_000;
    parameter NINE_POINT_999_SECONDS = 14'd9_999;
    parameter TEN_SECONDS = 14'd10_000;

    parameter ON = 1;
    parameter OFF = 0;

    parameter FLOAT = 2'd0; // display value types
    parameter DIGIT = 2'd1;
    parameter STRING = 2'd2;

    reg [13:0] best_reaction_time;
    reg [2:0] next_state;
    reg [13:0] random_trigger_time;
    
    always @(posedge clk) begin
        if(reset) begin
            best_reaction_time <= NINE_POINT_999_SECONDS; // maximum reaction time is best at first
        end
        if (reset | restart) begin
            next_state <= IDLE;
        end else if (enable) begin
            case (next_state)
                IDLE: begin
                    clear_display <= ON; // clear and disable all counters
                    run_prep_timer <= OFF;
                    run_reaction_timer <= OFF;
                    run_delay_timer <= OFF;
                    run_reset_timer <= OFF;
                    trigger_leds <= 8'h0;
                    run_trigger_timer <= OFF;
                    reset_counters <= ON;
                    enable_counters <= OFF;
                    if (ready == ON) begin
                        next_state <= PREPARATION;
                    end     
                end
                PREPARATION: begin
                    clear_display <= OFF;
                    reset_counters <= OFF;
                    enable_counters <= ON;
                    trigger_leds <= 8'h0;               
                    run_prep_timer <= ON;
                    display_data_type <= DIGIT;
                    display_value <= preparation_timer_count;
                    if (preparation_timer_count == 0) begin // when count down is finished
                        next_state  <= TRIGGER;
                        run_prep_timer <= OFF; 
                        random_trigger_time <= random_number; // keep random number
                    end 
                end 
                TRIGGER: begin
                    clear_display <= ON;
                    run_trigger_timer <= ON; // start reaction timer 
                    if(response == ON) begin // if button pressed move to failed
                        run_trigger_timer <= OFF;
                        next_state <= FAILED;
                    end else if(trigger_timer_count == random_trigger_time | trigger_timer_count >= FIVE_SECONDS) begin // if random time reached or grater than 5 econds
                        run_trigger_timer <= OFF;
                        trigger_leds <= 8'hFF; // glow leds
                        next_state <= WAIT_FOR_RESPONSE;
                    end
                end
                WAIT_FOR_RESPONSE: begin
                    run_reaction_timer <= ON;  // start measurement
                    if (response == ON) begin // if player reacts move to show time
                        run_reaction_timer <= OFF;
                        next_state <= SHOW_TIME;
                        trigger_leds <= 8'h0;
                    end else if (reaction_timer_count >= NINE_POINT_999_SECONDS) begin // cont exceeded move to failed
                        run_reaction_timer <= OFF;
                        trigger_leds <= 8'h0;
                        next_state <= FAILED;
                    end
                end
                SHOW_TIME: begin
                    clear_display <= OFF;
                    run_delay_timer <= ON;
                    if (reaction_timer_count <= best_reaction_time) begin
                        best_reaction_time <= reaction_timer_count; // update best reaction time
                    end
                    if (delay_timer_count > 7) begin // wait 2 seconds
                        display_data_type <= FLOAT;
                        display_value <= reaction_timer_count; // show current time
                    end else if (delay_timer_count > 5 && delay_timer_count <= 7) begin
                        display_data_type <= STRING;
                        display_value <= 14'd2; // show BESt in display
                    end else if (delay_timer_count <= 5 && delay_timer_count >= 1) begin
                        display_data_type <= FLOAT;
                        display_value <= best_reaction_time; // show best reaction time
                    end else begin
                        run_delay_timer <= OFF;
                        next_state <= PARKING; // wait for reset
                    end       
                end 
                FAILED: begin
                    clear_display <= OFF;
                    display_value <= 14'd1; // shoe FAIL in display
                    display_data_type <= STRING;
                    next_state <= PARKING;
                end
                PARKING: begin
                    run_reset_timer <= ON;
                    if(reset_timer_count == 0) begin // wait for 10 seconds and auto reset to IDLE
                        run_reset_timer <= OFF;
                        next_state <= IDLE;
                    end
                end
                default:
                    next_state <= IDLE;
            endcase
        end
    end
endmodule