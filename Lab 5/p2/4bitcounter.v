module bitCounter(enable, clock, Q, reset);
	input enable, clock, reset;
	output reg [3:0] Q;
	
	always@(posedge clock)
		begin 
			if(reset == 1'b1)
				Q <= 4'b0;
			else if(enable == 1'b1)
				Q <= Q + 1'b1;
			
			
	end
endmodule
