`timescale 1ns / 1ns // `timescale time_unit/time_precision
module timer(HEX0, SW, CLOCK_50, LEDR);
	output [9:0] LEDR;
	input [9:0] SW;
	input CLOCK_50;
	output [6:0] HEX0;
	
	wire [3:0] displayOut;
	wire [26:0] downCountOut;
	wire [26:0] w1;
	wire enable;
	
	
	mux4to1 u0(SW[1:0], w1);
	downCounter u1(w1, CLOCK_50, downCountOut,SW[9]);
	assign enable = (downCountOut == 0)?1:0;
	bitCounter u2(enable, CLOCK_50, displayOut, SW[9]);
	hexdisplay u3(displayOut, HEX0[6:0]);
	
		

endmodule
