module downCounter(D, clock, Q,reset);
	input [26:0] D;
	input clock, reset;
	output reg [26:0] Q;
	
	
	always@(posedge clock)
		begin
			if(Q == 27'b0)
				Q <= D;
			else if(reset == 1'b1)
				Q <= 27'b0;
			else
				Q <= Q - 1'b1;
	end
endmodule
