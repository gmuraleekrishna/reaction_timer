`timescale 1ns / 1ps

module counter (
    input run,
    input reset,
    input enable,
    input clk,
    output reg [13:0] count
    );

    always @(posedge clk) begin
        if (reset) begin
            count <= 14'd0;
        end else if(run && enable) begin
            count <= count + 1;
        end
    end
endmodule
