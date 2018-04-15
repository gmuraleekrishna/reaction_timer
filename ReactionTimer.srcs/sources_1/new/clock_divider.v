`timescale 1ns / 1ps

// From Lyle Roberts's DSM Lab Manual, Austalian National University
module clock_divider #(
    parameter integer THRESHOLD = 50_000_000
    ) (
    input clk,
    input reset,
    input enable,
    output reg divided_clk
    );

    reg [34:0] counter;

    always @(posedge clk) begin
        if (reset == 1 || counter >= THRESHOLD - 1) begin // count until THRESOLD and reset
            counter <= 0;
        end else if (enable == 1) begin
            counter <= counter + 1;
        end
    end

    always @(posedge clk) begin
        if (reset == 1) begin
            divided_clk <= 0;
        end else if (counter >= THRESHOLD - 1) begin
            divided_clk <= ~divided_clk; // change clock value when counter overflows
        end
    end
    
endmodule