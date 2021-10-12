` timescale 1ns/1ps

module MEM
#(
	parameter DATA_WIDTH = 32,
        parameter REGADDR_WIDTH = 5
 )
 (
	 input clk,
	 input wire ram_read_mem, ram_write_mem,
	 input wire[1 : 0] load_type_ex,
	 input wire [DATA_WIDTH-1 : 0] alu_result_mem,
	 input wire [DATA_WIDTH-1 : 0] rs2_data_mem,
	 output wire [DATA_WIDTH-1 : 0] ram_out_mem
 );

 RAM ram_mem
    (
      .clk(clk),
      .read_en(ram_read_mem), 
      .write_en(ram_write_mem), 
      .load_type(load_type_mem),
      .addr(alu_result_mem), 
      .data_in(rs2_data_mem), 
      .data_out(ram_out_mem)
    );

    endmodule
