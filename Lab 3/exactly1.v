module exactly1(A,B,C);
	input [3:0] A, B;
	output reg [7:0] C;
	
	always@(A or B)
		begin
			if((^A) && (B[0]+B[1]+B[2]+B[3] == 2'b10))
				C = 8'b1110000;
			else
				C = 8'b0000000;
		end	

endmodule
