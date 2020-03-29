`timescale 1ns/1ns

module animation
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
		KEY,
		SW,
		//LEDR,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input			CLOCK_50;				//	50 MHz
	// Declare your inputs and outputs here
	input [3:0] KEY;
	input [9:7] SW;
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	wire resetn;
	assign resetn = KEY[0];

	// Create the colour, x, y and writeEn wires that are inputs to the controller.

	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;
	wire enable, move, premove;

	wire[7:0] x_transfer;
	wire [6:0] y_transfer;

	wire draw, erase;

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	//image file (.MIF) for the controller.
	 vga_adapter VGA(
	 		.resetn(resetn),
	 		.clock(CLOCK_50),
	 		.colour(colour),
	 		.x(x),
	 		.y(y),
	 		.plot(writeEn),
	 		/* Signals for the DAC to drive the monitor. */
	 		.VGA_R(VGA_R),
	 		.VGA_G(VGA_G),
	 		.VGA_B(VGA_B),
	 		.VGA_HS(VGA_HS),
	 		.VGA_VS(VGA_VS),
	 		.VGA_BLANK(VGA_BLANK_N),
	 		.VGA_SYNC(VGA_SYNC_N),
	 		.VGA_CLK(VGA_CLK));
	 	defparam VGA.RESOLUTION = "160x120";
	 	defparam VGA.MONOCHROME = "FALSE";
	 	defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
	 	defparam VGA.BACKGROUND_IMAGE = "black.mif";

	// Put your code here. Your code should produce signals x,y,colour and writeEn
	// for the VGA controller, in addition to any other functionality your design may require.
	downCounter clock_60Hz(
		.clock(CLOCK_50),
		.out(enable)
		);
		
	up_counter times4(
		.clock(enable),
		.out(move),
		.preout(premove)
		);

	positionTrackerX(
		.move(move),
		.x_in(x),
		.x_out(x_transfer),
		.reset(resetn)
		);
	
	positionTrackerY(
		.move(move),
		.y_in(y),
		.y_out(y_transfer),
		.reset(resetn)
		);



 control c1(
		.reset(resetn), 
		.clock(enable),
		.move(move),
		.premove(premove), 
		.erase(erase),
		.draw(draw),
		.writeEn(writeEn)
		);

	datapath d1(
		.clock(CLOCK_50), 
		.reset(resetn), 
		.erase(erase),
		.draw(draw), 
		.writeEn(writeEn),
		.x_in(x_transfer),
		.y_in(y_transfer),
		.colour_in(SW[9:7]), 
		.x(x), 
		.y(y), 
		.colour(colour)
		);
	
endmodule

module control( reset, clock, move, premove, erase, draw, writeEn);
	input clock, reset, move, premove;
	output reg erase, draw, writeEn;

	reg [1:0] current_state, next_state;

	localparam
				S_WAIT 		= 2'd0,
				S_ERASE   = 2'd1,
				S_ERASE_PAUSE = 2'd2,
				S_DRAW		= 2'd3;

	always@(*)
	begin: state_table
		case(current_state)
		//Use premove and move off set to create draw and erase animation
			S_WAIT: next_state = premove ? S_ERASE : S_WAIT;
			S_ERASE: next_state = S_ERASE_PAUSE;
			S_ERASE_PAUSE: next_state = S_DRAW;
			S_DRAW: next_state = move ? S_DRAW : S_WAIT;
			default: next_state = S_WAIT;
		endcase
	end

	always@(*)
	begin: enable_signals
		erase = 1'b0;
		draw = 1'b0;
		writeEn = 1'b1;
		
		//erare -> draw -> repeat
		case(current_state)
			S_WAIT:
			begin
				writeEn <= 0;
			end
			S_ERASE:
			begin
				erase <= 1;
			end
			S_ERASE_PAUSE:
			begin
				writeEn <= 0;
			end
			S_DRAW:
			begin
				draw <= 1;
			end
		endcase
	end

	always@(posedge clock)
    begin: state_FFs
        if(!reset)
            current_state <= S_WAIT;
		else
            current_state <= next_state; 
    end
endmodule

module datapath(clock, reset, erase, draw, writeEn, x_in, y_in, colour_in, x, y, colour);
	input clock, reset, erase, draw, writeEn;
	input [7:0] x_in;
	input [6:0] y_in;
	input [2:0] colour_in;

	//
	reg [7:0] x_temp;
	reg [6:0] y_temp;
	reg [3:0] counter = 4'b0;

	reg temp = 1'b0;
	reg erase_temp = 1'b0;
	reg [2:0] colour_temp;

	output reg [7:0] x;
	output reg [6:0] y;
	output reg [2:0] colour;

	always@(*)
	begin
		x = x_temp + counter[1:0];
		y = y_temp + counter[3:2];
		colour = colour_temp;
	end

	always@(posedge clock)
	begin
		if(!reset) begin
			x_temp <= 8'b0;
			y_temp <= 7'b0;
			colour_temp <= 3'b0;
			counter <= 4'b0;
			temp <= 1'b0;
			erase_temp <= 1'b0;
		end
		if(erase && !erase_temp) begin
			counter <= 4'b0;
			erase_temp <= 1'b1;
			colour_temp <= 3'b0;
		end
		else if(erase && erase_temp) begin
			counter <= counter + 4'd1;
			colour_temp <= 3'b0;		
		end
		if (!erase && erase_temp) begin
			counter <= 4'b0;
			colour_temp <= 3'b0;
			erase_temp <= 1'b0;
		end
		else begin
			if(draw)
			begin
				x_temp <= x_in;
				y_temp <= y_in;
				colour_temp <= colour_in;
			end
			if(writeEn && !temp)
			begin
				counter <= 4'b0;
				temp <= 1'b1;
			end
			else if(writeEn && temp)
			begin
				counter <= counter + 4'd1;		
			end
			if (!writeEn)
			begin
				counter <= 4'b0;
				temp <= 1'b0;
			end
		end
	end
endmodule
