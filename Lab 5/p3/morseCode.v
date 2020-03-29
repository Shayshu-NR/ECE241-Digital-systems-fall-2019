module morseCode(CLOCK_50, KEY, SW, LEDR);
	input CLOCK_50;
	input [3:0] KEY;
	input [2:0] SW;
	output [9:0]LEDR;
	
	wire [15:0] letterSelect;
	wire [26:0] downCounterOut;
	wire enable;
	wire displayOut;
	
	muxselector u0(SW[2:0], letterSelect);
	downCounter u1(27'b001011111010111100000111111, CLOCK_50, KEY[1], KEY[0],downCounterOut);
	assign enable = (downCounterOut == 27'b000000000000000000000000000)?1:0;
	register u2(enable, letterSelect, KEY[0], KEY[1], CLOCK_50, displayOut);
	assign LEDR[0] = displayOut;
	
endmodule


module muxselector(SW, f);
	input [2:0] SW;
	output reg [15:0] f;
	wire [15:0] I = 16'b1010000000000000; //8secs
	wire [15:0] J = 16'b1011101110111000;
	wire [15:0] K = 16'b1110101110000000;
	wire [15:0] L = 16'b1011101010000000;
	wire [15:0] M = 16'b1110111000000000;
	wire [15:0] N = 16'b1110100000000000;
	wire [15:0] O = 16'b1110111011100000;
	wire [15:0] P = 16'b1011101110100000; 

	
	always@(*)
	begin
		case({SW[2],SW[1],SW[0]})
			3'b000: f = I;
			3'b001: f = J;
			3'b010: f = K;
			3'b011: f = L;
			3'b100: f = M;
			3'b101: f = N;
			3'b110: f = O;
			3'b111: f = P;
		endcase
	end
endmodule

module downCounter(LargeNum, clock, enable, reset ,Q);
	input clock, reset, enable;
	input [26:0] LargeNum;
	output reg [26:0] Q;
	
	always@(posedge clock)
		begin
			if(reset == 1'b0)
				Q <= LargeNum;
			else if(enable == 1'b0)
				Q <= Q;
			else if(Q == 27'b0)
				Q <= LargeNum;
			else
				Q <= Q - 1'b1;
	end
endmodule

module register(enable, letterIn, reset, load, clock, N);
	input enable, reset, clock, load;
	input [15:0] letterIn;
	output N;
	reg [15:0]Q;
	
	always@(posedge clock, negedge reset)
		begin
			if(reset == 1'b0)
				Q <= 16'b0;
			else if(load == 1'b0)
				Q <= letterIn;
			else if(enable == 1'b1)
				begin
					Q[15] <=Q[14];
					Q[14] <=Q[13];
					Q[13] <=Q[12];
					Q[12] <=Q[11];
					Q[11] <=Q[10];
					Q[10] <=Q[9];
					Q[9] <=Q[8];
					Q[8] <=Q[7];
					Q[7] <=Q[6];
					Q[6] <=Q[5];
					Q[5] <=Q[4];
					Q[4] <=Q[3];
					Q[3] <=Q[2];
					Q[2] <=Q[1];
					Q[1] <= Q[0];
					Q[0] <= 1'b0;
				end
			end
	assign N = Q[15];
endmodule 
		