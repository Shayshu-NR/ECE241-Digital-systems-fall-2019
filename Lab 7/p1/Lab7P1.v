module Lab7P1(SW,KEY, HEX0, HEX2, HEX4, HEX5);
	input [9:0] SW;
	input [3:0] KEY;
	output [6:0] HEX0, HEX2, HEX4, HEX5;
	wire [3:0] memOut, inter;
	
	ram32x4 u0(SW[8:4], KEY[0], SW[3:0], SW[9], memOut);
	assign inter = memOut;
	
	seg7 u1(HEX0[6:0], memOut);
	seg7 u2(HEX2[6:0], SW[3:0]);
	seg7 u3(HEX4[6:0], SW[7:4]);
	seg7 u4(HEX5[6:0],{3'b0,SW[8]});
	
endmodule


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


