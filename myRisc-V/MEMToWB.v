` timescale 1ns/1ps

module MENToWB
#(
	parameter DATA_WIDTH = 32,
        parameter REGADDR_WIDTH = 5
 )
 (
	input wire ram_read_mem, ram_write_mem, regs_write_mem,
     	input wire [DATA_WIDTH-1 : 0] alu_result_mem,
        input wire [REGADDR_WIDTH-1 : 0] rs1_addr_mem, rs2_addr_mem, rd_addr_mem,
    	input wire [DATA_WIDTH-1 : 0] ram_out_mem
	output wire ram_read_wb, ram_write_wb, regs_write_wb,
     	output wire [DATA_WIDTH-1 : 0] alu_result_wb,
        output wire [REGADDR_WIDTH-1 : 0] rs1_addr_wb, rs2_addr_wb, rd_addr_wb,
    	output wire [DATA_WIDTH-1 : 0] ram_out_wb
 );
 
 //transfer addr signals
 genReg #(.REG_WIDTH(5)) rs1_addr_mem_wb (.clk(clk), .rst(0), .en(1), .in(rs1_addr_mem), .out(rs1_addr_wb));
  genReg #(.REG_WIDTH(5)) rs2_addr_mem_wb (.clk(clk), .rst(0), .en(1), .in(rs2_addr_mem), .out(rs2_addr_wb));
  genReg #(.REG_WIDTH(5)) rd_addr_mem_wb (.clk(clk), .rst(0), .en(1), .in(rd_addr_mem), .out(rd_addr_wb));
 
 //transfer alu signals
  genReg result_mem_wb (.clk(clk), .rst(0), .en(1), .in(alu_result_mem), .out(alu_result_wb));
  genReg ram_trans (.clk(clk), .rst(0), .en(1), .in(ram_out_mem), .out(ram_out_wb));
 
 //transfer handshake signals
 genReg #(.REG_WIDTH(3)) handshake_mem_wb 
    (
      .clk(clk), 
      .rst(0), 
      .en(1), 
      .in({ram_read_mem, ram_write_mem, regs_write_mem}), 
      .out({ram_read_wb, ram_write_wb, regs_write_wb})
    );


    endmodule
