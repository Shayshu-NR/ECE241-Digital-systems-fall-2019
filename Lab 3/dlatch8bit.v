module dlatch8bit(data, clock, reset, dataout);
	input [3:0] data;
	input clock, reset;
	output reg [7:0] dataout;
	
	always@(posedge clock)
		begin
			if(reset == 0)
				dataout <= 8'b00000000;
			else
				dataout <= {4'b0000, data};
		end
		

endmodule
SS