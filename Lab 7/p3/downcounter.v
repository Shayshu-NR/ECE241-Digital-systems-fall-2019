module downCounter(input clock, output reg out);
reg [19:0] count = 20'b0;
always@(posedge clock)
begin
	if(count == 20'b0)//833_333)
		begin
		out <= 1'b1;
		count <= 20'b11001011011100110100;
		end
	else
		begin
		count <= count - 1'b1;
		out <= 1'b0;
		end
end
endmodule

