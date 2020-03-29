module mux2to1(x, y, s, m);
    input x; //select 0
    input y; //select 1
    input s; //select signal
    output m; //output
  
    assign m = s & y | ~s & x;
endmodule


module dflipflop (data, clock, reset, Q);

	input data,clock, reset;

	output reg  Q;
	
	always@(posedge clock)
		begin
			if(reset == 1'b1)
				Q <= 1'b0;
			else
				Q <=data;
		end

endmodule

