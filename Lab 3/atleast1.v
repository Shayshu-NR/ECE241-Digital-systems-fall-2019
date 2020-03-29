module atLeast1(A ,C);
	input [7:0] A;
	output reg [7:0] C;

always@(A)
	begin
		if(|A)
			C = 8'b0001111;
		else
			C = 8'b0000000;
	end
		
endmodule
