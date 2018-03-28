`timescale 1ns / 1ps

module multiple_seven_segment_display(
    input clk,
    input wire [3:0] digit1, 
    input wire [3:0] digit2, 
    input wire [3:0] digit3, 
    input wire [3:0] digit4,
    output wire [7:0] ssd_cathode,
    output wire [3:0] ssd_anode
    );

    wire clk_1kHz;
    wire clk_1kHz_rising_edge;
    reg [1:0] active_display;

    clock_divider #(
        .THRESHOLD(50_000)
        ) CLOCK_1kHZ_GENERATOR (
        .clk(clk),
        .reset(1'b0),
        .enable(1'b1),
        .divided_clk(clk_1kHz)
        );

    seven_segment_decoder SSD_DECODER (
      .active_display(active_display),
      .ssd(ssd_cathode),
      .ssd_anode(ssd_anode),
      .digit1(digit1), 
      .digit2(digit2), 
      .digit3(digit3),
      .digit4(digit4)
      );
      
    always @(posedge clk_1kHz) begin
        active_display <= active_display + 1;
    end
     
endmodule