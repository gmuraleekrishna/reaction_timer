`timescale 1ns / 1ps

module debouncer #(
    parameter integer THRESHOLD = 50
    )(
    input clk,
    input button_in,
    output button_out
    );

    wire divided_clk, divided_clk_rising_edge;
    reg [7:0] shift_reg;
    
    clock_divider #(
        .THRESHOLD(THRESHOLD)
        ) DEBOUNCE_CLOCK (
        .clk(clk),
        .reset(1'b0),
        .enable(1'b1),
        .divided_clk(divided_clk)
        );
    
    edge_detector DEBOUNCE_CLOCK_EDGE (
        .clk(clk),
        .signal_in(divided_clk),
        .rising_edge(divided_clk_rising_edge),
        .falling_edge(),
        .signal_out()
        );
    
    always @(posedge clk) begin
        shift_reg[0] <= button_in;

        if (divided_clk_rising_edge) begin
            shift_reg[7:1] <= shift_reg[6:0];
        end
    end
    
    assign button_out = &shift_reg[7:1];

endmodule
