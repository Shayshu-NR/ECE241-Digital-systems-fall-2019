module shiftReg_module(dataRight, dataLeft, LoadLeft, D, Loadn, clock, reset, Q);
	input dataRight, dataLeft, LoadLeft, D, Loadn, clock, reset;
	output Q;
	wire w1, w2,w3;
	
	mux2to1 RotateDirection(.x(dataRight), .y(dataLeft), .s(LoadLeft), .m(w1));
	mux2to1 ParallelLoad(.x(D),.y(w1),.s(Loadn),.m(w2));
	dflipflop u4(.data(w2), .clock(clock), .reset(reset), .Q(Q));
	
endmodule


module shiftReg_link (Data_IN, ASRight, RotateRight, ParallelLoadn, clock, reset, Q);
	input [7:0] Data_IN;
	input ASRight, RotateRight, ParallelLoadn, reset, clock;
	output [7:0] Q;
	wire w1;
	
	shiftReg_module u0(.dataLeft(Q[1]), .dataRight(Q[7]),.LoadLeft(RotateRight), .D(Data_IN[0]), .Loadn(ParallelLoadn), .clock(clock), .reset(reset), .Q(Q[0]));
	shiftReg_module u1(.dataLeft(Q[2]), .dataRight(Q[0]),.LoadLeft(RotateRight), .D(Data_IN[1]), .Loadn(ParallelLoadn), .clock(clock), .reset(reset), .Q(Q[1]));
	shiftReg_module u2(.dataLeft(Q[3]), .dataRight(Q[1]),.LoadLeft(RotateRight), .D(Data_IN[2]), .Loadn(ParallelLoadn), .clock(clock), .reset(reset), .Q(Q[2]));
	shiftReg_module u3(.dataLeft(Q[4]), .dataRight(Q[2]),.LoadLeft(RotateRight), .D(Data_IN[3]), .Loadn(ParallelLoadn), .clock(clock), .reset(reset), .Q(Q[3]));
	shiftReg_module u4(.dataLeft(Q[5]), .dataRight(Q[3]),.LoadLeft(RotateRight), .D(Data_IN[4]), .Loadn(ParallelLoadn), .clock(clock), .reset(reset), .Q(Q[4]));
	shiftReg_module u5(.dataLeft(Q[6]), .dataRight(Q[4]),.LoadLeft(RotateRight), .D(Data_IN[5]), .Loadn(ParallelLoadn), .clock(clock), .reset(reset), .Q(Q[5]));
	shiftReg_module u6(.dataLeft(Q[7]), .dataRight(Q[5]),.LoadLeft(RotateRight), .D(Data_IN[6]), .Loadn(ParallelLoadn), .clock(clock), .reset(reset), .Q(Q[6]));
	shiftReg_module u7(.dataLeft(w1), .dataRight(Q[6]),.LoadLeft(RotateRight), .D(Data_IN[7]), .Loadn(ParallelLoadn), .clock(clock), .reset(reset), .Q(Q[7]));
	mux2to1 ASShifter(.x(Q[0]), .y(Q[7]), .s(ASRight), .m(w1));

	assign LEDR = Q;
	
endmodule
