` timescale 1ns/1ps

module IDToEX
#(
 	 parameter DATA_WIDTH = 32,
         parameter REGADDR_WIDTH = 5
 )
 (
	 input wire [DATA_WIDTH-1 : 0]    i_imm_id, jump_offset_id, b_offset_id, store_offset_id,
 	 input wire [REGADDR_WIDTH-1 : 0] rs1_addr_id, rs2_addr_id, rd_addr_id,
	 input wire [DATA_WIDTH-1 : 0] rs1_data_id, rs2_data_id,
	 input wire ram_read_id, ram_write_id, regs_write_id,
    	 input wire [5 : 0] alu_op_id,
    	 input wire [1 : 0] load_type_id,op_b_sel_id,
	 output wire [DATA_WIDTH-1 : 0] i_imm_ex, b_offset_ex, store_offset_ex, jump_offset_ex,//imm signals
   	 output wire [4 : 0] rs1_addr_ex ,rs2_addr_ex, rd_addr_ex, //add signals
   	 output wire [DATA_WIDTH-1 : 0] rs1_data_ex, rs2_data_ex,//data signals
     	 output wire ram_read_ex,ram_write_ex,regs_write_ex,op_b_sel_ex,//control signals
    	 output wire [5 : 0] alu_op_ex,
    	 output wire [1 : 0] load_type_ex
 );
 
 // transfer imm signals
  transReg #(.REG_WIDTH(32)) imm_id_ex (.clk(clk), .rst(stall), .en(1), .in(i_imm_id), .out(i_imm_ex));
  transReg #(.REG_WIDTH(32)) jump_id_ex (.clk(clk), .rst(stall), .en(1), .in(jump_offset_id), .out(jump_offset_ex));
  transReg #(.REG_WIDTH(32)) b_id_ex (.clk(clk), .rst(stall), .en(1), .in(b_offset_id), .out(b_offset_ex));
  transReg #(.REG_WIDTH(32)) store_id_ex (.clk(clk), .rst(stall), .en(1), .in(store_offset_id), .out(store_offset_ex));

  //transfer adddr signals
  transReg #(.REG_WIDTH(5)) rs1_addr_id_ex (.clk(clk), .rst(stall), .en(1), .in(rs1_addr_id), .out(rs1_addr_ex));
  transReg #(.REG_WIDTH(5)) rs2_addr_id_ex (.clk(clk), .rst(stall), .en(1), .in(rs2_addr_id), .out(rs2_addr_ex));
  transReg #(.REG_WIDTH(5)) rd_addr_id_ex (.clk(clk), .rst(stall), .en(1), .in(rd_addr_id), .out(rd_addr_ex));

  //transfer data signals
   transReg #(.REG_WIDTH(32)) rs1_data_id_ex (.clk(clk), .rst(stall), .en(1), .in(rs1_data_id), .out(rs1_data_ex));
   transReg #(.REG_WIDTH(32)) rs2_data_id_ex (.clk(clk), .rst(stall), .en(1), .in(rs2_data_id), .out(rs2_data_ex));

   //transfer control signals
   transReg #(.REG_WIDTH(2)) load_type_id_ex(.clk(clk), .rst(stall), .en(1), .in(load_type_id), .out(load_type_ex));
   transReg #(.REG_WIDTH(2)) op_sel_id_ex(.clk(clk), .rst(stall), .en(1), .in(op_b_sel_id), .out(op_b_sel_ex));
   transReg #(.REG_WIDTH(3)) handshake_id_ex 
    (
      .clk(clk), 
      .rst(stall), 
      .en(1), 
      .in({ram_read_id, ram_write_id, regs_write_id}), 
      .out({ram_read_ex, ram_write_ex, regs_write_ex})
    );
   transReg #(.REG_WIDTH(6)) alu_op_id_ex(.clk(clk), .rst(stall), .en(1), .in(alu_op_id), .out(alu_op_ex));


   endmodule
