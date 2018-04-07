`timescale 1ns / 1ps

module TEST_counter_rev(
    );

    reg enable;
    reg reset;
    reg clk;
    reg run;
    wire [1:0]count;

    counter_rev UUT(
    	.reset(reset),
    	.clk(clk),
    	.enable(enable),
    	.run(run),
    	.count(count)
    	);

   always begin
        #1
        clk = ~clk;
    end

    initial begin
        enable = 0;
        reset = 0;
        clk = 0;

        #5
        reset = 1;

        #10
        reset = 0;
        enable = 1;
        run = 1;

    end
endmodule