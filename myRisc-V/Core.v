`timescale 1ns/1ps
//core of risc-v 
//module name: CORE
module CORE
#(
        parameter DATA_WIDTH = 32,
        parameter REGADDR_WIDTH = 5
 )
 (
        input clk,
        input reset
 );// input clk for clock signal and reset for reset signal at the beginning

    wire                       j,jr,branch; //jump signal
    wire                       stall, pc_en, flush; //harzard control signals
    wire [DATA_WIDTH-1 : 0]    branch_addr, jr_addr, jump_addr;//jump address
    wire [1 : 0]               forward_a, forward_b;// forward signals

    //IF variables
    wire [DATA_WIDTH-1 : 0]    pc_if;
    wire [DATA_WIDTH-1 : 0]    instruction_if;
    
    //ID variables
    wire [DATA_WIDTH-1 : 0]    instruction_id;
    wire [DATA_WIDTH-1 : 0]    pc_id;
    wire [DATA_WIDTH-1 : 0]    i_imm_id, jump_offset_id, b_offset_id, store_offset_id;//offset signals
    wire [REGADDR_WIDTH-1 : 0] rs1_addr_id, rs2_addr_id, rd_addr_id;//reg address signals
    wire [DATA_WIDTH-1 : 0] rs1_data_id, rs2_data_id;// reg data signals
    wire ram_read_id, ram_write_id, regs_write_id;// control signals from decoder
    wire [5 : 0] alu_op_id;
    wire [1 : 0] load_type_id,op_b_sel_id;

    //EX variables
    wire [DATA_WIDTH-1 : 0] i_imm_ex, b_offset_ex, store_offset_ex, jump_offset_ex;//imm signals
    wire [REGADDR_WIDTH-1 : 0] rs1_addr_ex ,rs2_addr_ex, rd_addr_ex; //add signals
    wire [DATA_WIDTH-1 : 0] rs1_data_ex, rs2_data_ex;//data signals
    wire ram_read_ex,ram_write_ex,regs_write_ex,op_b_sel_ex;//control signals
    wire [5 : 0] alu_op_ex;
    wire [1 : 0] load_type_ex;
    wire [DATA_WIDTH-1 : 0] alu_result_ex;

    //MEM variables
    wire ram_read_mem, ram_write_mem, regs_write_mem;
    wire [REGADDR_WIDTH-1 : 0] rs1_addr_mem, rs2_addr_mem, rd_addr_mem;
    wire [DATA_WIDTH-1 : 0] alu_result_mem;
    wire [1 : 0] load_type_mem;
    wire [DATA_WIDTH-1 : 0] rs2_data_mem;
    wire [REGADDR_WIDTH-1 : 0] rs1_addr_mem, rs2_addr_mem, rd_addr_mem;
    wire [DATA_WIDTH-1 : 0] ram_out_mem;

    //WB veriables
    `wire ram_read_wb, ram_write_wb, regs_write_wb,
    wire [REGADDR_WIDTH-1 : 0] rs1_addr_wb, rs2_addr_wb, rd_addr_wb;
    wire [DATA_WIDTH-1 : 0] regs_write_data;
    wire [DATA_WIDTH-1 : 0] alu_result_wb;
    wire [DATA_WIDTH-1 : 0] ram_out_wb;


 // IF start
 IF if_core(

	//module input
        .clk(clk);
	.reset(reset);
        .b_offset_ex(b_offse t_ex),
        .rs1_data_ex(rs1_data_ex),
        .jump_offset_ex(jump_offset_ex),
        .branch_addr(branch_addr),
        .jr_addr(jr_addr),
        .jump_addr(jump_addr),
        .flush(flush),
        .pc_en(pc_en),

	//module output
        .instruction_if(instruction_if),
	.pc_if(pc_if)
 );

 // transfer signals from IF to ID
 IFToID iftoid_core(

	//module input
	.clk(clk),
	.flush(clush),
	.reset(reset),
	.pc_en(pc_en),
	.instruction_if(instruction_if),
	.pc_if(pc_if),

	//module output
	.instruction_id(instruction_id),
	.pc_id(pc_id)
 );

 // ID start
 ID id_core(

	//module input
	.stall(stall),
	.pc_en(pc_en),
	.instruction_id(instruction_id),
	.pc_id(pc_id),
	.ram_read_ex(ram_read_ex),
	.rd_addr_ex(rd_addr_ex),
	.regs_write_wb(regs_write_wb),
	.rd_addr_wb(rd_addr_wb),
	.regs_write_data(regs_write_data),

	//module output
	.i_imm_id(i_imm_id),
	.jump_offset_id(jump_offset_id),
	.b_offset_id(b_offset_id),
	.store_offset_id(store_offset_id),
	.rs1_addr_id(rs1_addr_id),
	.rs2_addr_id(rs2_addr_id),
	.rd_addr_id(rd_addr_id),
	.rs1_data_id(rs1_data_id),
	.rs2_data_id(rs2_data_id),
	.load_type_id(load_type_id),
	.op_b_sel_id(op_b_sel_id),
	.ram_read_id(ram_read_id),
	.ram_write_id(ram_write_id),
	.regs_write_id(regs_write_id),
	.alu_op_id(alu_op_id),
	.j(j),
	.jr(jr),
	.branch(branch)
 );

 // transfer signals from ID to EX
 IDToEX idtoex_core(

	 //module input
	 .clk(clk),
	 .stall(stall),
	 .i_imm_id(i_imm_id),
 	 .jump_offset_id(jump_offset_id),
 	 .b_offset_id(b_offset_id),
	 .store_offset_id(store_offset_id)
	 .rs1_addr_id(rs1_addr_id),
	 .rs2_addr_id(rs2_addr_id),
	 .rd_addr_id(rd_addr_id),
	 .rs1_data_id(rs1_data_id),
 	 .rs2_data_id(rs2_data_id),
	 .load_type_id(load_type_id),
	 .op_b_sel_id(op_b_sel_id),
	 .ram_write_id(ram_write_id),
 	 .regs_write_id(regs_write_id),
	 .alu_op_id(alu_op_id),

	 //module output
	 .i_imm_ex(i_imm_ex),
 	 .jump_offset_ex(jump_offset_ex),
 	 .b_offset_ex(b_offset_id),
	 .store_offset_ex(store_offset_ex)
	 .rs1_addr_ex(rs1_addr_ex),
	 .rs2_addr_ex(rs2_addr_ex),
	 .rd_addr_ex(rd_addr_ex),
	 .rs1_data_ex(rs1_data_ex),
 	 .rs2_data_ex(rs2_data_ex),
	 .load_type_ex(load_type_ex),
	 .op_b_sel_ex(op_b_sel_ex),
	 .ram_write_ex(ram_write_ex),
 	 .regs_write_ex(regs_write_ex),
	 .alu_op_ex(alu_op_ex)
 );

 // EX start
  EX ex_core(

	  //module input
	  .regs_write_ex(regs_write_ex),
          .regs_write_mem(regs_write_mem),
	  .regs_write_wb(regs_write_wb),
	  .rs1_addr_ex(rs1_addr_ex),
          .rs2_addr_ex(rs2_addr_ex),
	  .rd_addr_mem(rd_addr_mem),
      	  .rd_addr_wb(rd_addr_wb),
          .forward_a(forward_a),
      	  .forward_b(forward_b),
	  .rs1_data_ex(rs1_data_ex),
	  .rs2_data_ex(rs2_data_ex),
	  .alu_result_wb(alu_result_wb),
	  .alu_result_mem(alu_result_mem),
	  .op_b_sel_ex(op_b_sel_ex),
	  .i_imm_ex(i_imm_ex),
	  .store_offset_ex(store_offset_ex)
	  .alu_op_ex(alu_op_ex),

	  //module output
	  .alu_result_ex(alu_result_ex)
 );

 //EX to MEM
 EXToMEM extomem_core(

	  //module input
	  .clk(clk),
	  .rs1_addr_ex(rs1_addr_ex),
	  .rs2_addr_ex(rs2_addr_ex),
	  .rd_addr_ex(rd_addr_ex),
	  .load_type_ex(lode_type_ex),
	  .ram_read_ex(ram_read_ex),
	  .ram_write_ex(ram_write_ex),
	  .regs_write_ex(regs_write_ex),
	  .rs2_data_ex(rs2_data_ex),
	  .alu_result_ex(alu_result_ex),

	  //module output
	  .rs1_addr_mem(rs1_addr_mem),
	  .rs2_addr_mem(rs2_addr_mem),
	  .rd_addr_mem(rd_addr_mem),
	  .load_type_mem(load_type_mem),
	  .ram_read_mem(ram_read_mem),
	  .ram_write_mem(ram_write_mem),
	  .regs_write_mem(regs_write_mem),
	  .rs2_data_mem_(rs2_data_mem),
	  .alu_result_mem(alu_result_mem)
 ();

  //MEM start
  MEM mem_core(

	  //module input
	  .clk(clk),
	  .ram_read_mem(ram_read_mem),
	  .ram_write_mem(ram_write_mem),
          .load_type_mem(load_type_mem),
	  .alu_result_mem(alu_result_mem)
	  .rs2_data_mem_(rs2_data_mem),

	  //module output
	  .ram_out_mem(ram_out_mem)
 );

 //MEM to WB
 MEMToWB memtowb_core(

	 //module input
	 .rs1_addr_mem(rs1_addr_mem),
	 .rs2_addr_mem(rs2_addr_mem),
	 .rd_addr_mem(rd_addr_mem),
	 .alu_result_mem(alu_result_mem),
	 .ram_out_mem(ram_out_mem),
	 .ram_read_mem(ram_read_mem),
	 .ram_write_mem(ram_write_mem),
	 .regs_write_mem(regs_write_mem),

	 //module output
	 .rs1_addr_wb(rs1_addr_wb),
	 .rs2_addr_wb(rs2_addr_wb),
	 .rd_addr_wb(rd_addr_wb),
	 .alu_result_wb(alu_result_wb),
	 .ram_out_wb(ram_out_wb),
	 .ram_read_wb(ram_read_wb),
	 .ram_write_wb(ram_write_wb),
	 .regs_write_wb(regs_write_wb)
 );

 //WB start
 WB wb_core(

	 //module input
	 .ram_read_wb(ram_read_wb),
         .ram_out_wb(ram_out_wb),
	 .alu_result_wb(alu_result_wb),

	 //module output
	 .regs_write_data(regs_write_data)
 );
 
 endmodule





	  



