` timescale 1ns/1ps

module EX
#(
	parameter DATA_WIDTH = 32,
        parameter REGADDR_WIDTH = 5
 )
 (
	 input wire ram_read_ex,
 	 input wire regs_write_mem,
	 wire regs_write_wb,
	 wire [REGADDR_WIDTH-1 : 0] rs1_addr_ex ,rs2_addr_ex, 
	 input wire [REGADDR_WIDTH-1: 0] rd_addr_mem,
	 input wire [REGADDR_WIDTH-1: 0] rd_addr_wb,
	 input wire [1 : 0] forward_a, forward_b,
	 input wire [DATA_WIDTH-1 : 0] rs1_data_ex, rs2_data_ex,
	 input wire [DATA_WIDTH-1 : 0] alu_result_wb,
	 input wire [DATA_WIDTH-1 : 0] alu_result_mem,
	 input wire p_b_sel_ex,
 	 input wire [DATA_WIDTH-1 : 0] i_imm_ex, store_offset_ex,
	 input wire [5 : 0] alu_op_ex,
	 output wire [DATA_WIDTH-1 : 0] alu_result_ex
 )

   wire [DATA_WIDTH-1 : 0]    oprand_a, oprand_b, oprand_b_temp;//alu signals


 forward forward_ex
    (
      .regs_write_ex(regs_write_ex),
      .regs_write_mem(regs_write_mem),
      .regs_write_wb(regs_write_wb),
      .rs1_addr_ex(rs1_addr_ex),
      .rs2_addr_ex(rs2_addr_ex),
      .rd_addr_mem(rd_addr_mem),
      .rd_addr_wb(rd_addr_wb),
      .forward_a(forward_a),
      .forward_b(forward_b)
   );

 ALUMUX alumux_ex_a
    (
      .sel(forward_a),
      .in0(rs1_data_ex),
      .in1(alu_result_wb),
      .in2(alu_result_mem),
      .in3(0),
      .mux_out(oprand_a)
    );
  ALUMUX alumux_ex_b
    (
      .sel(forward_b),
      .in0(rs2_data_ex),
      .in1(alu_result_wb),
      .in2(alu_result_mem),
      .in3(0),
      .mux_out(oprand_b_temp)
    );
 always@(*)
    case(op_b_sel_ex)
      2'b00: oprand_b = oprand_b_temp;
      2'b01: oprand_b = i_imm_ex;
      2'b10: oprand_b = store_offset_ex;
      default: oprand_b = 32'd0;
    endcase
 end

    ALU alu_ex(.opcode(alu_op_ex), .oprand_a(oprand_a), .oprand_b(oprand_b), .result(alu_result_ex));
    endmodule




