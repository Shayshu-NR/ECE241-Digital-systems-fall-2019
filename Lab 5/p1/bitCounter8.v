`timescale 1ns / 1ns // `timescale time_unit/time_precision
module bitCounter8(KEY, SW, HEX0, HEX1);
	input [3:0] KEY;
	input [1:0] SW;
	output [6:0] HEX0, HEX1;
	wire [7:0] w1;
	
	
	tFF8bit u0(SW[1], w1, KEY[0], SW[0]);
	hexDisplay u1(w1, HEX0, HEX1);
	
	

endmodule
