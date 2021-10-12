` timescale 1ns/1ps

module ALUMUX
#(
	parameter DATA_WIDTH = 32,
        parameter REGADDR_WIDTH = 5
 )
 (
	input [1 : 0] sel,
 	input [DATA_WIDTH-1 : 0] in0,
	input [DATA_WIDTH-1 : 0] in1,
	input [DATA_WIDTH-1 : 0] in2,
	input [DATA_WIDTH-1 : 0] in3,
	output reg [DATA_WIDTH-1 : 0] mux_out
 );

 always@(*)
	 case(sel)
		 2'b00: mux_out = in0
		 2'b01: mux_out = in1
		 2'b10: mux_out = in2
		 default: mux_out = in3
	 endcase
 end
 endmodule
