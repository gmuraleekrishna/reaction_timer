`timescale 1ns / 1ps
module lfsr (
    input clk,
    input reset,
    output reg [13:0] random_number
    );
 
    reg [13:0] bit;
 
    always @(posedge clk) begin
        if(reset) begin
            random_number = 14'd9987; // seed
        end else begin
            bit  = ((random_number >> 1'b1) ^ (random_number >> 2'd2) ^ (random_number >> 2'd3) ^ (random_number >> 3'd5) ) & 1; // random number polinomial 
            random_number =  (random_number >> 1) | (bit << 6'd13); // feedback
        end
    end
endmodule
