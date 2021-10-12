` timescale 1ns/1ps

module EXToMEM
#(
	parameter DATA_WIDTH = 32,
        parameter REGADDR_WIDTH = 5
 )
 (
	 input clk,
	 input wire [REGADDR_WIDTH-1 : 0] rs1_addr_ex ,rs2_addr_ex, rd_addr_ex,
	 input wire [1 : 0] load_type_ex,
	 input wire ram_read_ex,ram_write_ex,regs_write_ex,
	 input wire [DATA_WIDTH-1 : 0] rs2_data_ex,
	 input wire [DATA_WIDTH-1 : 0] alu_result_ex,
	 output wire [REGADDR_WIDTH-1 : 0] rs1_addr_mem, rs2_addr_mem, rd_addr_mem,
	 output wire [1 : 0] load_type_mem,
	 output wire ram_read_mem, ram_write_mem, regs_write_mem,
         wire [DATA_WIDTH-1 : 0] rs2_data_mem,
	 wire [DATA_WIDTH-1 : 0] alu_result_mem
 );

 //transfer addr signals
  genReg #(.REG_WIDTH(5)) rs1_addr_ex_mem (.clk(clk), .rst(0), .en(1), .in(rs1_addr_ex), .out(rs1_addr_mem));
  genReg #(.REG_WIDTH(5)) rs2_addr_ex_mem (.clk(clk), .rst(0), .en(1), .in(rs2_addr_ex), .out(rs2_addr_mem));
  genReg #(.REG_WIDTH(5)) rd_addr_ex_mem (.clk(clk), .rst(0), .en(1), .in(rd_addr_ex), .out(rd_addr_mem));

 //transfer data signals
 genReg #(.REG_WIDTH(2)) load_type_ex_mem (.clk(clk), .rst(0), .en(1), .in(load_type_ex), .out(load_type_mem));
 genReg rs2_data_ex_mem (.clk(clk), .rst(0), .en(1), .in(rs2_data_ex), .out(rs2_data_mem));
 genReg result_ex_mem (.clk(clk), .rst(0), .en(1), .in(alu_result_ex), .out(alu_result_mem));

 //transfer hanshake signals
 genReg #(.REG_WIDTH(3)) handshake_ex_mem 
    (
      .clk(clk), 
      .rst(0), 
      .en(1), 
      .in({ram_read_ex, ram_write_ex, regs_write_ex}), 
      .out({ram_read_mem, ram_write_mem, regs_write_mem})
    );

    endmodule





