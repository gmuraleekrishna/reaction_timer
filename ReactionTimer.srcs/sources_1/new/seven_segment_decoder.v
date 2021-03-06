`timescale 1ns / 1ps
module seven_segment_decoder(
    input [1:0] active_display,
    input wire [4:0] digit1, 
    input wire [4:0] digit2, 
    input wire [4:0] digit3, 
    input wire [4:0] digit4,
    input wire decimal,
    input clear,
    output reg [3:0] ssd_anode,
    output reg [7:0] ssd
    );

    parameter ON = 1;
    parameter OFF = 0;

    reg [4:0] ssd_number;
    reg dp;

    always @(*) begin
        case (ssd_number)
            5'd0 : ssd = 8'b00_00_00_01; // 0
            5'd1 : ssd = 8'b01_00_11_11; // 1
            5'd2 : ssd = 8'b00_01_00_10; // 2
            5'd3 : ssd = 8'b00_00_01_10; // 3
            5'd4 : ssd = 8'b01_00_11_00; // 4
            5'd5 : ssd = 8'b00_10_01_00; // 5
            5'd6 : ssd = 8'b00_10_00_00; // 6
            5'd7 : ssd = 8'b00_00_11_11; // 7
            5'd8 : ssd = 8'b00_00_00_00; // 8
            5'd9 : ssd = 8'b00_00_01_00; // 9
            
            5'd10 : ssd = 8'b00_11_10_00; // F
            5'd11 : ssd = 8'b00_00_10_00; // A
            5'd12 : ssd = 8'b01_00_11_11; // I
            5'd13 : ssd = 8'b01_11_00_01; // L            
            
            5'd14 : ssd = 8'b00_10_00_01; // G
            
            5'd15 : ssd = 8'b00_00_00_00; //B
            5'd16 : ssd = 8'b00_11_00_00; //E
            5'd17 : ssd = 8'b00_10_01_00; //S
            5'd18 : ssd = 8'b01_11_00_00; //t
            
            5'd19 : ssd = 8'b11_11_11_11; // Display off

            default : ssd = 8'b11_11_11_11;
        endcase
        ssd[7] = ~dp;
    end
    always @(*) begin
        if(clear) begin
            ssd_anode <= 4'b1111; // none active
        end else begin
            case(active_display)
                2'd0 : begin
                    ssd_number <= digit4; // last ssd
                    ssd_anode <= 4'b1110;
                    dp <= OFF;
                end
                2'd1 : begin
                    ssd_number <= digit3; //second last ssd
                    ssd_anode <= 4'b1101;
                    dp <= OFF;
                end
                2'd2 : begin
                    ssd_number <= digit2; // 2nd ssd
                    ssd_anode <= 4'b1011;
                    dp <= OFF;
                end
                2'd3 : begin
                    ssd_number <= digit1; // first ssd
                    ssd_anode <= 4'b0111;
                    dp <= decimal;
                end

                default : begin
                    ssd_number <= 4'd15; // undefined
                    ssd_anode <= 4'b1111; // none active
                    dp <= OFF;
                end
            endcase
        end
    end
endmodule