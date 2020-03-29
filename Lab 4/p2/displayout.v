module displayout(SW, AluOut, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR);

input [7:0] SW;
input [7:0] AluOut;
output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
output [7:0] LEDR;

aluseg7display u1(SW,HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR, AluOut);


endmodule
