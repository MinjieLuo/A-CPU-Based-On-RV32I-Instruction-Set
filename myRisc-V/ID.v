`timescale 1ns/1ps

module ID
#(
	parameter DATA_WIDTH = 32,
        parameter REGADDR_WIDTH = 5
 )
 (
	input clk,
	input stall,
	input pc_en,
 	input wire [DATA_WIDTH-1 : 0]    instruction_id,
	input wire ram_read_ex, rd_addr_ex,
	input wire regs_write_wb,
	input wire [REGADDR_WIDTH-1 : 0] rd_addr_wb,
	input wire [DATA_WIDTH-1 : 0] regs_write_data,
	output wire [DATA_WIDTH-1 : 0] i_imm_id, jump_offset_id, b_offset_id, store_offset_id,
	output wire [REGADDR_WIDTH-1 : 0] rs1_addr_id, rs2_addr_id, rd_addr_id,
	output wire [DATA_WIDTH-1 : 0] rs1_data_id, rs2_data_id,
	output wire ram_read_id, ram_write_id, regs_write_id,
	output wire [5 : 0] alu_op_id,
	output wire [1 : 0] load_type_id,op_b_sel_id,
	output wire j, jr, branch
 )

 assign i_imm_id         =   {{21{instruction_id[31]}},instruction_id[30:20]};
 assign jump_offset_id   =   {{13{instruction_id[31]}}, instruction_id[19:12], instruction_id[20], instruction_id[30:21]};
 assign b_offset_id      =   {{21{instruction_id[31]}}, instruction_id[7], instruction_id[30:25], instruction_id[11:8]};
 assign store_offset_id  =   {{21{instruction_id[31:25]}}, instruction_id[11:7]}; 

 decoder decoder_ex
    (
     //module input
     .ins(instruction_id),
     .rs1_data(rs1_data_id),
     .rs2_data(rs2_data_id),
     //module output
     .ram_read(ram_read_id),
     .ram_write(ram_write_id),
     .regs_write(regs_write_id),
     .J(j),
     .JR(jr),
     .Branch(branch),
     .flush(flush),
     .op_b_sel(op_b_sel_id),
     .load_type(load_type_id),
     .alu_op(alu_op_id)
    );

 registers registers_ex
    (
      .write_en(regs_write_wb), 
      .addr1(rs1_addr_id),
      .addr2(rs2_addr_id), 
      .write_addr(rd_addr_wb), 
      .data1(rs1_data_id), 
      .data2(rs2_data_id), 
      .write_data(regs_write_data)
    );
 dependenceDetect dependenceDetect_ex
    (
      .ram_read_ex(ram_read_ex),
      .rd_addr_ex(rd_addr_ex),
      .rs1_addr_id(rs1_addr_id),
      .rs2_addr_id(rs2_addr_id),
      .stall(stall),
      .pc_en(pc_en)
    );


