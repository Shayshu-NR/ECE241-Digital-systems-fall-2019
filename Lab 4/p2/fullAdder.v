//Ripple adder skeleton
module fulladder(input a, b, cin, output s, cout);
	assign s = cin^a^b;
	assign cout = (b & a) | (cin & b) | (cin & a);
endmodule


//Ripple adder with 4 full adders
module rippleAdder(a, s);
	input [7:0] a;
	output [4:0] s;
	wire w0, w1, w2;
	
	fulladder block1 (.s(s[0]), .cout(w0), .a(a[0]), .b(a[4]), .cin(1'b0));
	fulladder block2 (.s(s[1]), .cout(w1), .a(a[1]), .b(a[5]), .cin(w0));
	fulladder block3 (.s(s[2]), .cout(w2), .a(a[2]), .b(a[6]), .cin(w1));
	fulladder block4 (.s(s[3]), .cout(s[4]), .a(a[3]), .b(a[7]), .cin(w2));
endmodule

