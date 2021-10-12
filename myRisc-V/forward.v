` timescale 1ns/1ps

module forward
#(
	parameter RGEADDR_WIDTH = 5
 )
  (
   input                regs_write_ex,
   input                regs_write_mem,
   input                regs_write_wb,
   input      [4 : 0]   rs1_addr_ex,
   input      [4 : 0]   rs2_addr_ex,
   input      [4 : 0]   rd_addr_mem,
   input      [4 : 0]   rd_addr_wb,
   output reg [1 : 0]   forward_a,
   output reg [1 : 0]   forward_b
  );
//rs1 forwward signal
  assign forward_a[1] = regs_write_ex && regs_write_mem && (rs1_addr_ex == rd_addr_mem);
  assign forward_a[0] = regs_write_ex && regs_write_wb && !((rs1_addr_ex == rd_addr_mem) && regs_write_mem) && (rs1_addr_ex == rd_addr_wb);

//rs2 forward signal
  assign forward_b[1] = regs_write_ex && regs_write_mem && (rs2_addr_ex == rd_addr_mem);
  assign forward_b[0] = regs_write_ex && regs_write_wb && !((rs2_addr_ex == rd_addr_mem) && regs_write_mem) && (rs2_addr_ex == rd_addr_wb);

endmodule

