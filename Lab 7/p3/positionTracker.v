module positionTracker(move, x_in, x_out, y_in, y_out);
	input move;
	input [7:0] x_in;
	input [6:0] y_in;
	output reg [7:0] x_out;
	output reg [6:0] y_out;
	reg direction = 1'b0;	//0 = right, 1 = left
	
//	//Move is essentially a clock that will tell control to draw at x and y at a time a bit after the erase
	always@(posedge move) begin

		if(!direction) begin
			if(x_in >= 8'd156) begin
				direction <= 1'b1;
				x_out <= x_in - 1'b1;
			end
			else begin
				x_out <= x_in + 1'b1;
			end
		end
		else begin
			if(x_in == 8'd0) begin
				direction <= 1'b0;
				x_out <= x_in + 1'b1;
			end
			else begin
				x_out <= x_in - 1'b1;
			end
		end
	end
	
	
endmodule
