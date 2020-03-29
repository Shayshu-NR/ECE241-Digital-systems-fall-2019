  
`timescale 1ns/1ns

module fill(SW, 
			KEY, 
			CLOCK_50,
			LEDR,
			VGA_CLK,   						
			VGA_HS,							
			VGA_VS,							
			VGA_BLANK_N,						
			VGA_SYNC_N,						
			VGA_R,   				
			VGA_G,	 					
			VGA_B);

output			VGA_CLK;   				//	VGA Clock
output			VGA_HS;					//	VGA H_SYNC
output			VGA_VS;					//	VGA V_SYNC
output			VGA_BLANK_N;			//	VGA BLANK
output			VGA_SYNC_N;				//	VGA SYNC
output	[9:0]	VGA_R;   				//	VGA Red[9:0]
output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
						
input [9:0] SW;
input [3:0] KEY;
output [6:0] LEDR;
input CLOCK_50;

wire xEnable, yEnable, colourEnable;

wire [7:0] x; 
wire [6:0] y; 
wire [2:0] colour;

wire reset, paint, black, load;
assign reset = KEY[0];
assign black = KEY[2];
assign load = KEY[3];

wire controlReset; //resets x,y and colour to 0. So, this allows us to have a different type of reset for blackening the screen.
wire countUp;

//datapath
datapath dp(
			.clock(CLOCK_50),
			.reset(reset),
			.dataIn(SW),
			.xEnable(xEnable),
			.yEnable(yEnable),
			.colourEnable(colourEnable),
			.x(x),
			.y(y),
			.colour(colour),
			.controlReset(controlReset),
			.countUp(countUp)
			);
				
control ctrl(
			.clock(CLOCK_50),
			.reset(reset),
			.go(load),
			.xEnable(xEnable),
			.yEnable(yEnable),
			.colourEnable(colourEnable),
			.black(black),
			.paintRequest(KEY[1]),
			.paint(paint),
			.controlReset(controlReset),
			.countUp(countUp),
			.states(LEDR[6:0])
			);
			
	 vga_adapter VGA(
	 		.resetn(reset),
	 		.clock(CLOCK_50),
	 		.colour(colour),
	 		.x(x),
	 		.y(y),
	 		.plot(paint),
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
endmodule 

module control(clock, reset, go, xEnable, yEnable, colourEnable, black, paintRequest, paint, controlReset, countUp, states);
	input clock, reset, go, black, paintRequest;
	output reg xEnable, yEnable, colourEnable, paint, controlReset, countUp;
	
	 reg [2:0] current_state, next_state; 
	 
	 output wire [6:0] states;
	 assign states = {next_state, 1'b0, current_state};
    
    localparam  S_LOAD_X_WAIT = 3'd0,
                S_LOAD_X = 3'd1,
                S_LOAD_YC_WAIT = 3'd2,
                S_LOAD_YC = 3'd3,
				S_PLOT_WAIT = 3'd4,
				S_PLOT = 3'd5,
				S_BLACK_RESET = 3'd6,
				S_BLACK_LOOP = 3'd7;
					 
    always@(*)  
    begin: state_table 
            case (current_state)
                S_LOAD_X_WAIT: next_state = go ? S_LOAD_X_WAIT : S_LOAD_X; // Loop in current state until value is input
                S_LOAD_X: next_state = go ? S_LOAD_YC_WAIT : S_LOAD_X; 	// Loop in current state until go signal goes low
                S_LOAD_YC_WAIT: next_state = go ? S_LOAD_YC_WAIT : S_LOAD_YC; // Loop in current state until value is input
				S_LOAD_YC : next_state = go ? S_PLOT_WAIT : S_LOAD_YC; 
				S_PLOT_WAIT: next_state = paintRequest ? S_PLOT_WAIT : S_PLOT;
				S_PLOT: next_state = paintRequest ? S_LOAD_X_WAIT : S_PLOT;
				S_BLACK_RESET: next_state = S_BLACK_LOOP;
				S_BLACK_LOOP: next_state = go ? S_BLACK_LOOP : S_LOAD_X;
            default: next_state = S_LOAD_X_WAIT;
        endcase
    end

        initial xEnable = 1'b0;
        initial yEnable = 1'b0;
        initial colourEnable = 1'b0;
		initial paint = 1'b0;
		initial controlReset = 1'b0;
		initial countUp = 1'b0;   
	   
	always @(*)
    begin: enable_signals
        // By default make all our signals 0
        xEnable = 1'b0;
        yEnable = 1'b0;
        colourEnable = 1'b0;
  		paint = 1'b0;
	  	controlReset = 1'b0;
	  	countUp = 1'b0;

        case (current_state)
            S_LOAD_X: 
            	begin
                	xEnable = 1'b1;
                end
            S_LOAD_YC: 
            	begin
	                yEnable = 1'b1;
					colourEnable = 1'b1;
                end
			S_PLOT: 
				begin
					paint = 1'b1;
				end
			S_BLACK_RESET: 
				begin
				controlReset = 1'b1;
				paint = 1'b1;
					
				end
			S_BLACK_LOOP: 
				begin
					paint = 1'b1;
					countUp = 1'b1;
				end
		   endcase
		end
			
    always@(posedge clock)
    begin: state_FFs
        if(!reset)
            current_state <= S_LOAD_X_WAIT;
		  else begin
			if (!black)
				current_state <= S_BLACK_RESET;
			else
            current_state <= next_state;
		  end 
    end
	 
endmodule 


module datapath(clock, reset, dataIn, xEnable, yEnable, colourEnable, x, y, colour, controlReset, countUp);
	input [9:0] dataIn;
	input clock, reset;
	input xEnable, yEnable, colourEnable;
	input controlReset, countUp;
	
	reg [7:0] x_in;
	reg [6:0] y_in;
	reg [2:0] colour_in;
	output reg [2:0] colour;
	reg [3:0] fourBitCounter;
	reg [14:0] screenClear;

	output reg [7:0] x;
	output reg [6:0] y;	
	
	always @(*) 
	begin
		if(!countUp) begin
		x <= x_in + fourBitCounter[1:0];
		y <= y_in + fourBitCounter[3:2];
		colour <= colour_in;
		end
		else 
		if(!controlReset) begin
		x <= screenClear[7:0];
		y <= screenClear [14:8];
		colour <= colour_in;
		end
		
	end	
	

	always @(posedge clock) 
	begin
		if (!reset | controlReset) 
		begin
			x_in <= 8'b0;
			y_in <= 8'b0;
			colour_in <= 3'b0;
			fourBitCounter <= 4'b0;
			screenClear <= 15'b0;
		end
		else
		begin
			if (xEnable)
				x_in <= {1'b0, dataIn[6:0]};
				
			if (yEnable)
				y_in <= dataIn[6:0]; 
				
			if (colourEnable)
				colour_in <= dataIn[9:7];
				
			if (countUp) 
			begin
				fourBitCounter <= 4'b0;
				if (y_in > 8'd120 & x_in < 8'd160) 
				begin
					x_in <= x_in + 8'd1;
					y_in <= 8'd0;
				end 
				if (y < 8'd120)
					y_in <= y_in + 8'd1;
			end
			if (!countUp)
				fourBitCounter <= fourBitCounter + 1;
				
				
			if (controlReset) 
			begin
				screenClear <= 15'b0;
				if (y_in > 8'd120 & x_in < 8'd160) 
				begin
					x_in <= x_in + 8'd1;
					y_in <= 8'd0;
				end 
				if (y < 8'd120)
					y_in <= y_in + 8'd1;
			end
			if(!controlReset) 
				screenClear <= screenClear + 1;
		end
	end
	
endmodule 