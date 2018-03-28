`timescale 1ns / 1ps
module seven_segment_decoder(
    input [1:0] active_display,
    input wire [3:0] digit1, 
    input wire [3:0] digit2, 
    input wire [3:0] digit3, 
    input wire [3:0] digit4,
    output reg [3:0] ssd_anode,
    output reg [7:0] ssd
    );

    parameter ON = 1;
    parameter OFF = 0;

    reg [3:0] ssd_number;
    reg dp;

    always @(*) begin
        case (ssd_number)
            4'd0 : ssd = 8'b00_00_00_01;
            4'd1 : ssd = 8'b01_00_11_11;
            4'd2 : ssd = 8'b00_01_00_10;
            4'd3 : ssd = 8'b00_00_01_10;
            4'd4 : ssd = 8'b01_00_11_00;
            4'd5 : ssd = 8'b00_10_01_00;
            4'd6 : ssd = 8'b00_10_00_00;
            4'd7 : ssd = 8'b00_00_11_11;
            4'd8 : ssd = 8'b00_00_00_00;
            4'd9 : ssd = 8'b00_00_01_00;
            default : ssd = 8'b11_11_11_11;
        endcase
        ssd[7] = ~dp;
    end
    always @(*) begin
        case(active_display)
            2'd0 : begin
                ssd_number <= digit4;
                ssd_anode <= 4'b1110;
                dp <= OFF;
            end
            2'd1 : begin
                ssd_number <= digit3;
                ssd_anode <= 4'b1101;
                dp <= OFF;
            end
            2'd2 : begin
                ssd_number <= digit2;
                ssd_anode <= 4'b1011;
                dp <= OFF;
            end
            2'd3 : begin
                ssd_number <= digit1;
                ssd_anode <= 4'b0111;
                dp <= ON;
            end

            default : begin
                ssd_number <= 4'd15; // undefined
                ssd_anode <= 4'b1111; // none active
                dp <= OFF;
            end
        endcase
    end
endmodule