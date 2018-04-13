`timescale 1ns / 1ps

module display (
    input wire [13:0] value, 
    input clk,
    input clear,
    input wire [1:0] type,
    output wire [7:0] ssd_cathode,
    output wire [3:0] ssd_anode
    );
    
    parameter FLOAT = 2'd0;
    parameter DIGIT = 2'd1;
    parameter STRING = 2'd2;
    
    reg [4:0] digit1;
    reg [4:0] digit2;
    reg [4:0] digit3;
    reg [4:0] digit4;
    reg [13:0] reminder1; 
    reg [13:0] reminder2;
    reg [13:0] reminder3;

    reg float;

    multiple_seven_segment_display MULTI_SSD (
        .clk(clk),
        .digit1(digit1),
        .digit2(digit2),
        .digit3(digit3),
        .digit4(digit4),
        .decimal(float),        
        .ssd_cathode(ssd_cathode),
        .ssd_anode(ssd_anode),
        .clear(clear)
        );

    parameter TEN_TO_POWER_3 = 14'd1_000;
    parameter TEN_TO_POWER_2 = 14'd100;
    parameter TEN_TO_POWER_1 = 14'd10;
    parameter TEN_TO_POWER_0 = 14'd1;

    always @(*) begin
        if (type == FLOAT) begin
            digit1 = value / TEN_TO_POWER_3; // digit before decimal point (dp)
            reminder1 = value % TEN_TO_POWER_3; // rest of the number after dp
            digit2 = reminder1 / TEN_TO_POWER_2; // extract first digit after dp
            reminder2 = reminder1 % TEN_TO_POWER_2; // rest of the number after frist digit after dp
            digit3 = reminder2 / TEN_TO_POWER_1;// extract second digit after dp
            reminder3 = reminder2 % TEN_TO_POWER_1; // rest of the number after second digit after dp
            digit4 = reminder3 / TEN_TO_POWER_0; // extract third digit after dp
            float = 1'b1;
        end else if (type == DIGIT) begin 
            digit4 <= value[4:0];
            digit1 <= 5'd19;
            digit2 <= 5'd19; // switch off other displays.
            digit3 <= 5'd19;
            float <= 1'b0;
        end else if (type == STRING) begin
            float <= 1'b0;
            case(value)
                14'd1: begin
                    digit1 <= 5'd10; // F
                    digit2 <= 5'd11; // A
                    digit3 <= 5'd12; // I
                    digit4 <= 5'd13; // L
                end
                14'd2: begin
                    digit1 <= 5'd15; //B
                    digit2 <= 5'd16; //E   
                    digit3 <= 5'd17; //S
                    digit4 <= 5'd18; //t
                end    
                default: begin
                    digit1 <= 5'd19; 
                    digit2 <= 5'd19; 
                    digit3 <= 5'd19;
                    digit4 <= 5'd19; 
                end
            endcase
            //dictionay
        end
    end
endmodule