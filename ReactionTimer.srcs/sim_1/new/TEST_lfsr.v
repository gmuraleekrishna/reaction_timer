`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/28/2018 12:25:04 PM
// Design Name: 
// Module Name: TEST_lfsr
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module TEST_lfsr(

    );

reg clk, reset;
wire [32:0] random number;

lfsr UUT(
	.clk(clk),
	.reset(reset),
	.random_number(random_number)
	);

wire [32:0] temp;

always begin
	
	#1
	clk = ~clk;
end

initial begin
	reset = 1;
	random_number = 33'd8998957;

	#5 
	reset = 0;
	temp = random_number;

	#15
	temp = random_number;

	#25
	temp = random_number;
end
endmodule
