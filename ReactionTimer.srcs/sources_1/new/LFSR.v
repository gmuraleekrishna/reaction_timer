`timescale 1ns / 1ps
module lsfr (
    input clk,
    input reset,
    output reg [32:0] random_number
    );
 
    reg [32:0] bit;
    reg [32:0] start_state;
 
    always @(posedge clk) begin
        if(reset) begin
            start_state = 33'd3457;
            random_number = start_state;
        end else begin
            bit  = ((random_number >> 0) ^ (random_number >> 2'd2) ^ (random_number >> 2'd3) ^ (random_number >> 3'd5) ) & 1;
            random_number =  (random_number >> 1) | (bit << 6'd33);
        end
    end
endmodule
