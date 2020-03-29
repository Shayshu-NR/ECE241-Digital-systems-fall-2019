`timescale 1ns / 1ns // `timescale time_unit/time_precision


module mux6to1(input Input0,Input1,Input2,Input3,Input4,Input5, MuxSelect0,MuxSelect1,MuxSelect2, output reg Out);
		
	
		always@(*)
			begin
			case ({MuxSelect0,MuxSelect1,MuxSelect2}) 
				3'b000: Out = Input0; 
				3'b001: Out = Input1; 
				3'b010: Out = Input2;
				3'b011: Out = Input3;
				3'b100: Out = Input4;
				3'b101: Out = Input5;
				default: Out = Input0;
			endcase 
		end
endmodule

module muxtofpga(SW, LEDR);
	input [9:0] SW;
	output [9:0] LEDR;
	
	mux6to1 u1 (SW[0],SW[1],SW[2],SW[3],SW[4],SW[5],SW[7],SW[8],SW[9],LEDR[0]);

endmodule