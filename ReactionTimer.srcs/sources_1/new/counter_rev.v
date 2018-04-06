`timescale 1ns / 1ps



module counter_rev(
    input run,
    input reset,
    input enable,
    input clk,
    output reg [1:0] count
    );

    always @(posedge clk) begin
        if (reset || ~enable) begin
            count <= 2'd3;
        end else if(run && enable) begin
            count <= count - 1;
        end
    end
endmodule
