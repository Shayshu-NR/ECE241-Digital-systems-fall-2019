module up_counter(input clock, output reg out, preout);
reg [3:0] count = 4'b0;
always@(posedge clock)
begin
	
	//out is used in the control path and is output ever 15/60 seconds
	//So it outputs every 0.25 seconds, so just aver preout
	if(count == 4'b0010)
		begin
		out <= 1;
		count <= 0;
		preout <= 0;
		end
	else
		begin
		//Checks every 12 frames essentially, or in this case 12/60 seconds 
		//So it outputs 1 every 0.2 seconds
		if(count == 4'd0001)
			preout <= 1'b1;
		else begin
			preout <=1'b0;
		end
		count <= count+1'b1;
		out <= 1'b0;
		end
end
endmodule