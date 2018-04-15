`timescale 1ns / 1ps



module reverse_counter #(
    parameter integer INITIAL_VALUE = 3
)(
    input run,
    input reset,
    input enable,
    input clk,
    output reg [3:0] count
    );

    always @(posedge clk) begin
        if (reset) begin
            count <= INITIAL_VALUE; // set initial value to support different counters
        end else if(run && enable) begin
            count <= count - 1;
        end
    end
endmodule
