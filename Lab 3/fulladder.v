`timescale 1ns / 1ns // `timescale time_unit/time_precision

//Skeleton of a full adder
module fulladder(input a, b, cin, output s, cout);

assign s = cin^a^b;
assign cout = (b & a) | (cin & b) | (cin & a);

endmodule


//Ripple adder with 4 full adders
module rippleAdder(SW, LEDR);
input [9:0] SW;
output [9:0] LEDR;

wire w0, w1, w2;

fulladder block1 (.s(LEDR[0]), .cout(w0), .a(SW[4]), .b(SW[0]), .cin(SW[8]));
fulladder block2 (.s(LEDR[1]), .cout(w1), .a(SW[5]), .b(SW[1]), .cin(w0));
fulladder block3 (.s(LEDR[2]), .cout(w2), .a(SW[6]), .b(SW[2]), .cin(w1));
fulladder block4 (.s(LEDR[3]), .cout(LEDR[9]), .a(SW[7]), .b(SW[3]), .cin(w2));

endmodule


