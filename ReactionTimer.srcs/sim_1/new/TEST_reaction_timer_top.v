`timescale 1ns / 1ps

module TEST_reaction_timer_top(
    );

    reg enable, reset, response_btn, clk;
    wire [32:0] reaction_time;
    wire trigger_led, debounced_btn;
    wire [1:0] next_state;
    wire [3:0] digit1;
    wire [3:0] digit2;
    wire [3:0] digit3;
    wire [3:0] digit4;

    reaction_timer_top UUT(
        .enable(enable),
        .reset(reset),
        .response_btn(response_btn),
        .clk(clk),
        .trigger_led(trigger_led),
        .digit1(digit1),
        .digit2(digit2),
        .digit3(digit3),
        .digit4(digit4),
        .next_state(next_state)
        );

    always begin
        #1
        clk = ~clk;
    end

    initial begin
        enable = 0;
        reset = 0;
        clk = 0;
        response_btn = 0;
        
        #5
        reset = 1;

        #5
        reset = 0;

        #5
        enable = 1; 

        #100544
        response_btn = 1;

        #60
        response_btn = 0;
    end


endmodule
