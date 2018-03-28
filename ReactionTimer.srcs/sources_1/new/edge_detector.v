`timescale 1ns / 1ps

module edge_detector (
    input clk,
    input wire signal_in,
    output wire signal_out,
    output reg rising_edge,
    output reg falling_edge
    );

    reg [1:0] pipeline;
    reg [3:0] counter;
    always @(*) begin
        pipeline[0] = signal_in;
    end

    always @(posedge clk) begin
        pipeline[1] <= pipeline[0];
    end

    always @(*) begin
        if (pipeline == 2'b01) begin
            rising_edge <= 1;
        end else if (pipeline == 2'b10) begin
            falling_edge <= 1;
        end else begin
            rising_edge <= 0;
            falling_edge <= 0;
        end
    end

    assign signal_out = pipeline[1];
    
endmodule
