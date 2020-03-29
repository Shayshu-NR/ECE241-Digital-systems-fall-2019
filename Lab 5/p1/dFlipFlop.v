module dFlipFlop(D, Q, clock, reset);
	input D, clock, reset;
	output reg Q;
	
	always@(posedge clock, negedge reset)
		begin 
			if(reset == 0)
				Q <= 0;
			else
				Q = D;
		end
endmodule 