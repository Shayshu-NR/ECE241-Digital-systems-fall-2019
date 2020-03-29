module mux4to1(SW, rate);
	input [1:0] SW;
	wire [26:0] out1, out2, out3, out4;
	output reg [26:0]rate;
	assign out1 = 27'b000000000000000000000000001;
	assign out2 = 27'b101111101011110000011111111;
	assign out3 = 27'b010111110101111000001111111;
	assign out4 = 27'b001011111010111100000111111;
	
	always@(*)
		begin
			case({SW[1], SW[0]}) 
				2'b00: rate = out1;
				2'b01: rate = out2;
				2'b10: rate = out3;
				2'b11: rate = out4;
				default: rate = out1;
			endcase          
		end
endmodule

