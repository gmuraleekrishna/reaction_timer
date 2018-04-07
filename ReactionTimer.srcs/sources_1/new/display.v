`timescale 1ns / 1ps

module display (
    input wire [13:0] value, 
    input clk,
    input wire is_float,
    output wire [7:0] ssd_cathode,
    output wire [3:0] ssd_anode
    );
    
    reg [3:0] digit1;
    reg [3:0] digit2;
    reg [3:0] digit3;
    reg [3:0] digit4;
    reg [13:0] reminder1; 
    reg [13:0] reminder2;
    reg [13:0] reminder3;

    multiple_seven_segment_display MULTI_SSD (
        .clk(clk),
        .digit1(digit1),
        .digit2(digit2),
        .digit3(digit3),
        .digit4(digit4),        
        .ssd_cathode(ssd_cathode),
        .ssd_anode(ssd_anode)
        );

    parameter TEN_TO_POWER_3 = 14'd1_000;
    parameter TEN_TO_POWER_2 = 14'd100;
    parameter TEN_TO_POWER_1 = 14'd10;
    parameter TEN_TO_POWER_0 = 14'd1;

    always @(*) begin
        if (is_float) begin
            digit1 = value / TEN_TO_POWER_3; // digit before decimal point (dp)
            reminder1 = value % TEN_TO_POWER_3; // rest of the number after dp
            digit2 = reminder1 / TEN_TO_POWER_2; // extract first digit after dp
            reminder2 = reminder1 % TEN_TO_POWER_2; // rest of the number after frist digit after dp
            digit3 = reminder2 / TEN_TO_POWER_1;// extract second digit after dp
            reminder3 = reminder2 % TEN_TO_POWER_1; // rest of the number after second digit after dp
            digit4 = reminder3 / TEN_TO_POWER_0; // extract third digit after dp
        end else begin 
            digit4 = value[3:0];
            digit1 = 4'd15;
            digit2 = 4'd15; // switch off other displays.
            digit3 = 4'd15;
        end 
    end
endmodule