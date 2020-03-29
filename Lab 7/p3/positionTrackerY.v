module positionTrackerY(move, y_in, y_out, reset);
	input move, reset;
	input [6:0] y_in;

	reg direction = 1'b0;	//0 = down, 1 = up

	output reg [6:0] y_out;

	always@(posedge move)
	begin
		if(reset == 1'b0)
			y_out <= 7'b0;
			
		if(!direction) begin
			if(y_in >= 7'd116) begin
				direction <= 1'b1;
				y_out <= y_in - 1'b1;
			end
			else begin
				y_out <= y_in + 1'b1;
			end
		end
		else begin
			if(y_in == 7'd0) begin
				direction <= 1'b0;
				y_out <= y_in + 1'b1;
			end
			else begin
				y_out <= y_in - 1'b1;
			end
		end
	end
	
endmodule