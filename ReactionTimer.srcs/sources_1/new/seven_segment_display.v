`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/06/2018 09:51:17 PM
// Design Name: 
// Module Name: seven_segment_display
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


module seven_segment_display(
	input reset,
	input enable,
	input [3:0] value,
	output [6:0]ssd_cathode,	
	output wire [3:0] ssd_anode
	);

	seven_segment_decoder BCDTOSSD (
		.ssd_number(value),
		.ssd(ssd_cathode)
		);

	assign ssd_anode = 4'b1110;
endmodule
