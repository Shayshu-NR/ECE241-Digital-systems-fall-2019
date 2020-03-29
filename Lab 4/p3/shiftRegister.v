`timescale 1ns / 1ns // `timescale time_unit/time_precision


module shiftRegister(SW, KEY, LEDR);
	
	input [9:0] SW;
	input [3:0] KEY;
	output [9:0] LEDR;
	

	
	shiftReg_link u1(SW[7:0], KEY[3], KEY[2], KEY[1], KEY[0], SW[9], LEDR[7:0]);
	
	assign LEDR[9:8] = 2'b00;
	
endmodule
