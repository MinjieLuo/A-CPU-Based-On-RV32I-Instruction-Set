`timescale 1ns / 1ns

module dependence_detect
  (
   input            ram_read_ex,
   input  [4 : 0]   rd_addr_ex,
   input  [4 : 0]   rs1_addr_id,
   input  [4 : 0]   rs2_addr_id,
   output           stall,
   output           pc_en
  );
   assign stall = ram_read_ex && ((rd_addr_ex == rs1_addr_id) || (rd_addr_ex == rs2_addr_id));
   assign pc_en = ~stall;
endmodule

