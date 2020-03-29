module tFlipFlop(enable, Q, clock, resetb);
	input enable, clock, resetb;
	output Q;
	wire w1;
	
	assign w1 = enable^Q;
	dFlipFlop u0(w1, Q, clock, resetb);
	

endmodule

module tFF8bit(enable, Q, clock, resetb);
	input enable, clock , resetb;
	output [7:0] Q;
	wire w0, w1, w2, w3, w4, w5, w6;
	
	tFlipFlop u0(enable, Q[0], clock, resetb);
	assign w0 = enable & Q[0];
	tFlipFlop u1(w0, Q[1], clock, resetb);
	assign w1 = w0 & Q[1];
	tFlipFlop u2(w1, Q[2], clock, resetb);
	assign w2 = w1 & Q[2];
	tFlipFlop u3(w2, Q[3], clock, resetb);
	assign w3 = w2 & Q[3];
	tFlipFlop u4(w3, Q[4], clock, resetb);
	assign w4 = w3 & Q[4];
	tFlipFlop u5(w4, Q[5], clock, resetb);
	assign w5 = w4 & Q[5];
	tFlipFlop u6(w5, Q[6], clock, resetb);
	assign w6 = w5 & Q[6];
	tFlipFlop u7(w6, Q[7], clock, resetb);
	
	
endmodule

	
	
