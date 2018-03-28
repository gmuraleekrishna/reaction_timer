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

    parameter TRIGGER = 2'd0;
    parameter COUNT = 2'd1;
    parameter WAIT_FOR_RESPONSE = 2'd2;
    parameter SHOW_TIME = 2'd3;

    parameter ON = 1;
    parameter OFF = 0;

    reg run_timer;
    wire [32:0] counter_time;
    reg [1:0] next_state;
    reg [32:0] display_value;

    debouncer DEBOUNCE_RESPONSE_BTN (
        .clk(clk),
        .button_in(response_btn),
        .button_out(db_response_btn)
        );
    
    counter REACTION_COUNTER (
        .run(run_timer),
        .count(counter_time),
        .reset(reset),
        .clk(clk)
        );

    display DISPLAY_RESPONSE_TIME (
            .clk(clk),
            .value(display_value),
            .reset(reset),
            .ssd_cathode(ssd_cathode),
            .ssd_anode(ssd_anode)
        );

    // divide the reaction time by 10^9, 10^8, 10^8 to extract the digits for seconds and micro seconds
    // send it to each SSDs
    // done

    always @(posedge clk) begin
        if (reset) begin
            display_value <= 33'd0;
            next_state <= TRIGGER;
            run_timer <= OFF;
        end else if (enable) begin
            case (next_state)
                TRIGGER: begin
                    trigger_led <= ON;
                    next_state <= COUNT;
                end
                COUNT: begin 
                    run_timer <= ON; 
                    next_state <= WAIT_FOR_RESPONSE;
                end
                WAIT_FOR_RESPONSE: begin
                    display_value <= counter_time;
                    if (db_response_btn == ON || counter_time >= 33'd10_000_000_000) begin
                        run_timer <= OFF;
                        next_state <= SHOW_TIME;
                        trigger_led <= OFF;
                    end
                end
                SHOW_TIME:
                    display_value <= counter_time;   
                default:
                    next_state <= TRIGGER;
            endcase
        end
    end
endmodule
