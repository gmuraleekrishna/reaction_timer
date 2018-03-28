`timescale 1ns / 1ps

module counter (
    input run,
    input reset,
    input clk,
    output reg [32:0] count
    );

    always @(posedge clk) begin
        if (reset) begin
            count <= 33'd0;
        end else if(run) begin
            count <= count + 1;
        end
    end
endmodule
