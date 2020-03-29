//Hex display;
module seg7(LED, c);
input [3:0] c;
output [6:0] LED;

	assign LED[0] = (~c[3] & ~c[2] & ~c[1] & c[0]) | (~c[3] & c[2] & ~c[1] & ~c[0]) | (c[3] & ~c[2] & c[1] & c[0]) | (c[3] & c[2] & ~c[1] & c[0]);
	assign LED[1] = (~c[3] & c[2] & ~c[1] & c[0]) | (~c[3] & c[2] & c[1] & ~c[0]) | (c[3] & ~c[2] & c[1] & c[0]) | (c[3] & c[2] & ~c[1] & ~c[0]) | (c[3] & c[2] & c[1] & ~c[0]) | (c[3] & c[2] & c[1] & c[0]);
	assign LED[2] = (~c[3] & ~c[2] & c[1] & ~c[0]) | (c[3] & c[2] & ~c[1] & ~c[0]) | (c[3] & c[2] & c[1] & ~c[0]) | (c[3] & c[2] & c[1] & c[0]);
	assign LED[3] = (~c[3] & ~c[2] & ~c[1] & c[0]) | (~c[3] & c[2] & ~c[1] & ~c[0]) | (~c[3] & c[2] & c[1] & c[0]) | (c[3] & ~c[2] & ~c[1] & c[0]) | (c[3] & ~c[2] & c[1] & ~c[0]) | (c[3] & c[2] & c[1] & c[0]) ;
	assign LED[4] = (~c[3] & ~c[2] & ~c[1] & c[0]) | (~c[3] & ~c[2] & c[1] & c[0]) | (~c[3] & c[2] & ~c[1] & ~c[0]) | (~c[3] & c[2] & ~c[1] & c[0]) | (~c[3] & c[2] & c[1] & c[0]) | (c[3] & ~c[2] & ~c[1] & c[0]);
	assign LED[5] = (~c[3] & ~c[2] & ~c[1] & c[0]) | (~c[3] & ~c[2] & c[1] & ~c[0]) | (~c[3] & ~c[2] & c[1] & c[0])  | (~c[3] & c[2] & c[1] & c[0]) | (c[3] & c[2] & ~c[1] & c[0]);
	assign LED[6] = (~c[3] & ~c[2] & ~c[1] & ~c[0]) | ( ~c[3] & ~c[2] & ~c[1] & c[0]) | (~c[3] & c[2] & c[1] & c[0]) | (c[3] & c[2] & ~c[1] & ~c[0]);

endmodule


module aludisplay(SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR, Out);
	
	input [7:0] Out;
	input [7:0] SW;
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output [7:0] LEDR;

	seg7 B(.c(SW[3:0]), .LED(HEX0[6:0]));

	seg7 zero0(.c(4'b0000), .LED(HEX1[6:0]));

	seg7 A(.c(4'b0000), .LED(HEX2[6:0]));

	seg7 zero1(.c(4'b0000), .LED(HEX3[6:0]));

	seg7 aluout03(.c(Out[3:0]), .LED(HEX4[6:0]));

	seg7 aluout74(.c(Out[7:4]), .LED(HEX5[6:0]));
	
	assign LEDR[7:0] = Out;
	
endmodule



             