`timescale 1ns / 1ps

module display (
    input wire [32:0] value,
    input wire [1:0] prep_timer_count_value,
    input reset,
    input clk,
    output wire [7:0] ssd_cathode,
    output wire [3:0] ssd_anode
    );

    reg [3:0] digit1;
    reg [3:0] digit2;
    reg [3:0] digit3;
    reg [3:0] digit4;

    reg [1:0] count_down;
    
    reg [32:0] reminder1; 
    reg [32:0] reminder2;
    reg [32:0] reminder3;

    multiple_seven_segment_display MULTI_SSD (
        .clk(clk),
        .digit1(digit1),
        .digit2(digit2),
        .digit3(digit3),
        .digit4(digit4),
        .count_down(count_down),
        .ssd_cathode(ssd_cathode),
        .ssd_anode(ssd_anode)
        );

    parameter TEN_TO_POWER_8 = 33'd100_000_000;
    parameter TEN_TO_POWER_7 = 33'd10_000_000;
    parameter TEN_TO_POWER_6 = 33'd1_000_000;
    parameter TEN_TO_POWER_5 = 33'd100_000;

    always @(*) begin
        count_down = prep_timer_count_value;
        digit1 = value / TEN_TO_POWER_8; // digit before decimal point (dp)
        reminder1 = value % TEN_TO_POWER_8; // rest of the number after dp
        digit2 = reminder1 / TEN_TO_POWER_7; // extract first digit after dp
        reminder2 = reminder1 % TEN_TO_POWER_7; // rest of the number after frist digit after dp
        digit3 = reminder2 / TEN_TO_POWER_6;// extract second digit after dp
        reminder3 = reminder2 % TEN_TO_POWER_6; // rest of the number after second digit after dp
        digit4 = reminder3 / TEN_TO_POWER_5; // extract third digit after dp
    end
endmodule