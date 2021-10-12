`timescale 1ns/1ps

module WB
#(
	parameter DATA_WIDTH = 32,
        parameter REGADDR_WIDTH = 5
 )
 (
	 input wire ram_read_wb,
	 input wire [DATA_WIDTH-1 : 0] ram_out_wb,
	 input wire [DATA_WIDTH-1 : 0] alu_result_wb,
	 output wire [DATA_WIDTH-1 : 0] regs_write_data
 );

 assign regs_write_data = ram_read_wb ? ram_out_wb : alu_result_wb;

 endmodule



