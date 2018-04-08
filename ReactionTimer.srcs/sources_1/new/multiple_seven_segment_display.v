`timescale 1ns / 1ps

module multiple_seven_segment_display(
    input clk,
    input clear,
    input wire [4:0] digit1, 
    input wire [4:0] digit2, 
    input wire [4:0] digit3, 
    input wire [4:0] digit4, 
    input wire decimal,  
    output wire [7:0] ssd_cathode,
    output wire [3:0] ssd_anode
    );

    reg [1:0] active_display;

    seven_segment_decoder SSD_DECODER (
      .active_display(active_display),
      .ssd(ssd_cathode),
      .ssd_anode(ssd_anode),
      .digit1(digit1), 
      .digit2(digit2), 
      .digit3(digit3),
      .digit4(digit4),
      .decimal(decimal)
      );
      
    always @(posedge clk) begin
        if(clear) begin
            active_display <= 2'd5;
        end else begin
            active_display <= active_display + 1;
        end
    end     
endmodule