module norGate(Q, norQ,clock);
	input [26:0] Q;
	input clock;
	output reg norQ;
	
	always@(posedge clock)
		begin
			if(Q == 0)
				norQ <= 1;
			else
				norQ <= 0;
	end
	

endmodule
	