`timescale 1ns / 1ns // `timescale time_unit/time_precision

module ALU(KEY, SW, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, AluOut);
	input [3:0] KEY;
	input [9:0] SW;
	output [7:0] LEDR;
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output reg [7:0] AluOut;
	wire DataOut;
	wire [7:0] w0 ,w1, w2, w3, w4, w5, w6, registerOut;
	
	rippleAdder u0({registerOut[3:0],SW[3:0]}, w0);
	verilogadder u1(SW[3:0], registerOut[3:0], w1);
	xornand u2(SW[3:0], registerOut[3:0], w2);
	atLeast1 u3({SW[3:0], registerOut[3:0]},w3);
	exactly1 u4(SW[3:0], registerOut[3:0], w4);
	significantout u5(SW[3:0],registerOut[3:0], w5);
	dlatch8bit u6(AluOut, KEY[0], SW[9], w6);
	
	
	always@(*)
		begin
			case(KEY[3:1])
				3'b000: AluOut = w0;
				3'b001: AluOut = w1;
				3'b010: AluOut = w2;
				3'b011: AluOut = w3;
				3'b110: AluOut = w4;
				3'b100: AluOut = w5; 
				3'b101: AluOut = w6;
				default: AluOut = 8'b00000000;
			endcase
		end
	
	dlatch8bit u9(AluOut, KEY[0], SW[9], registerOut);
	
	aludisplay u8(SW[3:0], HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR, registerOut);
	
	
	
endmodule






