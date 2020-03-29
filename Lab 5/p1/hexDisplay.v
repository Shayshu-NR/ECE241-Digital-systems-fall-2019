module seg7(input c0, c1, c2, c3, output LED0, LED1, LED2, LED3, LED4, LED5, LED6);

//Essentially a giant if statement for each LED segment and when they're supposed to turn off
assign LED0 = (~c3 & ~c2 & ~c1 & c0) | (~c3 & c2 & ~c1 & ~c0) | (c3 & ~c2 & c1 & c0) | (c3 & c2 & ~c1 & c0);

assign LED1 = (~c3 & c2 & ~c1 & c0) | (~c3 & c2 & c1 & ~c0) | (c3 & ~c2 & c1 & c0) | (c3 & c2 & ~c1 & ~c0) | (c3 & c2 & c1 & ~c0) | (c3 & c2 & c1 & c0);

assign LED2 = (~c3 & ~c2 & c1 & ~c0) | (c3 & c2 & ~c1 & ~c0) | (c3 & c2 & c1 & ~c0) | (c3 & c2 & c1 & c0);

assign LED3 = (~c3 & ~c2 & ~c1 & c0) | (~c3 & c2 & ~c1 & ~c0) | (~c3 & c2 & c1 & c0) | (c3 & ~c2 & ~c1 & c0) | (c3 & ~c2 & c1 & ~c0) | (c3 & c2 & c1 & c0) ;

assign LED4 = (~c3 & ~c2 & ~c1 & c0) | (~c3 & ~c2 & c1 & c0) | (~c3 & c2 & ~c1 & ~c0) | (~c3 & c2 & ~c1 & c0) | (~c3 & c2 & c1 & c0) | (c3 & ~c2 & ~c1 & c0);

assign LED5 = (~c3 & ~c2 & ~c1 & c0) | (~c3 & ~c2 & c1 & ~c0) | (~c3 & ~c2 & c1 & c0)  | (~c3 & c2 & c1 & c0) | (c3 & c2 & ~c1 & c0);

assign LED6 = (~c3 & ~c2 & ~c1 & ~c0) | ( ~c3 & ~c2 & ~c1 & c0) | (~c3 & c2 & c1 & c0) | (c3 & c2 & ~c1 & ~c0);
 

endmodule

module hexDisplay(CounterBits, HEX0, HEX1);
	input [7:0] CounterBits;
	output [6:0] HEX0, HEX1;
	
	seg7 u0(CounterBits[0],CounterBits[1], CounterBits[2], CounterBits[3], HEX0[0], HEX0[1], HEX0[2], HEX0[3], HEX0[4], HEX0[5], HEX0[6]);
	seg7 u1(CounterBits[4],CounterBits[5], CounterBits[6], CounterBits[7], HEX1[0], HEX1[1], HEX1[2], HEX1[3], HEX1[4], HEX1[5], HEX1[6]);

endmodule
