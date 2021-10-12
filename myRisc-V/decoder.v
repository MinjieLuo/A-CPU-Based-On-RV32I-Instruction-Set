` timescale 1ns/1ps

module decoder
 #(
    localparam INS_WIDTH    =    32,

    //opcode
    localparam JUMP_OP      =    7'b1101111,
    localparam JR_OP        =    7'b1100111,
    localparam BRANCH_OP    =    7'b1100011,
    localparam LOAD_OP      =    7'b0000011,
    localparam STORE_OP     =    7'b0100011,
    localparam I_TYPE_OP    =    7'b0010011,
    localparam R_TYPE_OP    =    7'b0110011,

    //funct3
    localparam BEQ_FUNCT    =    3'b000,
    localparam BNE_FUNCT    =    3'b001,
    localparam BLT_FUNCT    =    3'b100,
    localparam BGE_FUNCT    =    3'b101,
    localparam BLTU_FUNCT   =    3'b110,
    localparam BGEU_FUNCT   =    3'b111,
    localparam LW_FUNCT     =    3'b010,
    localparam LH_FUNCT     =    3'b001,
    localparam LB_FUNCT     =    3'b000,
    localparam SW_FUNCT     =    3'b010,
    localparam ADDI_FUNCT   =    3'b000,
    localparam SLTI_FUNCT   =    3'b010,
    localparam SLTIU_FUNCT  =    3'b011,
    localparam XORI_FUNCT   =    3'b100,
    localparam ORI_FUNCT    =    3'b110,
    localparam ANDI_FUNCT   =    3'b111,
    localparam SLLI_FUNCT   =    3'b001,
    localparam SRLI_FUNCT   =    3'b101,
    localparam SRAI_FUNCT   =    3'b101,
    localparam ADD_FUNCT    =    3'b000,
    localparam SUB_FUNCT    =    3'b000,
    localparam SLL_FUNCT    =    3'b001,
    localparam SLT_FUNCT    =    3'b010,
    localparam SLTU_FUNCT   =    3'b011,
    localparam XOR_FUNCT    =    3'b100,
    localparam SRL_FUNCT    =    3'b101,
    localparam SRA_FUNCT    =    3'b101,
    localparam OR_FUNCT     =    3'b110,
    localparam AND_FUNCT    =    3'b111,

    //funct7
    localparam SUB_SRA_FUNCT =   7'b0100000

    //ALU
    localparam alu_ram   =  6'b000000,
    localparam alu_add   =  6'b000001,
    localparam alu_sub   =  6'b001010,
    localparam alu_slt   =  6'b000010,
    localparam alu_sltu  =  6'b000011,
    localparam alu_sll   =  6'b000100,
    localparam alu_srl   =  6'b000101,
    localparam alu_sra   =  6'b000110,
    localparam alu_xor   =  6'b000111,
    localparam alu_or    =  6'b001000,
    localparam alu_and   =  6'b001001,
    localparam alu_nop   =  6'b111111
  )
  (
    input      [31 : 0]    ins,
    input  reg [31 : 0]    rs1_data,
    input  reg [31 : 0]    rs2_data,
    output reg             J,
    output reg             JR,
    output reg             Branch,
    output reg             ram_read,
    output reg             ram_write,
    output reg             regs_write,
    output reg [1 : 0]     op_b_sel,
    output reg [1 : 0]     load_type,
    output reg [5 : 0]     alu_op,
    output reg             flush
  );

 //instruction decode signals
  wire [6 : 0] opcode, funct7;
  wire [2 : 0] funct3;
  assign opcode = ins[14 : 12];
  assign funct3 = ins[14 : 12];
  assign funct7 = ins[31 : 25];

  //jump signals
  assign J = opcode == JUMP_OP;
  assign JR = opcode == JR_OP;
  assign flush = j || jr || branch;

  //set branch signals
  always@(*)
  begin
    if (opcode == BRANCH_OP) begin
      case(funct3)
        BEQ_FUNCT: begin
                    if (rs1_data == rs2_data)
                      Branch = 1;
                    else
                      Branch = 0;
                   end
        BNE_FUNCT: begin
                    if (rs1_data != rs2_data)
                      Branch = 1;
                    else
                      Branch = 0;
                   end  
        BLT_FUNCT: begin
                    if ($signed(rs1_data) < $signed(rs2_data))
                      Branch = 1;
                    else
                      Branch = 0;
                   end
        BGE_FUNCT: begin
                    if ($signed(rs1_data) >= $signed(rs2_data))
                      Branch = 1;
                    else
                      Branch = 0;
                   end
        BLTU_FUNCT: begin
                      if (rs1_data < rs2_data)
                        Branch = 1;
                      else
                        Branch = 0;
                    end 
        BGEU_FUNCT: begin
                      if (rs1_data >= rs2_data)
                        Branch = 1;
                      else
                        Branch = 0;
                    end
      endcase
    end
  end

  //set load and store signals
  always@(*)
  begin
    if (opcode == LOAD_OP)begin
      op_b_sel = 2'b01;
      case(funct3)
        LW_FUNCT: load_type = 2'b00;
        LH_FUNCT: load_type = 2'b01;
        LB_FUNCT: load_type = 2'b10;
        default:  load_type = 2'b11;
      endcase
    end
    if (opcode == STORE_OP)
      op_b_sel = 2'b10;
  end

  //define instruction type
  wire   r_type_ins, i_type_ins, load_ins, store_ins;
  assign load_ins   = op == LOAD_OP;
  assign store_ins  = op == STORE_OP;
  assign i_type_ins = op == I_TYPE_OP;
  assign r_type_ins = op == R_TYPE_OP;
  
  //send instruction type to control signals
  assign ram_read   = load_ins;
  assign ram_write  = store_ins;
  assign regs_write = r_type_ins || i_type_ins || load_ins;

  //set alu code
  always@(*)
  begin
    case(opcode)
      LOAD_OP:    alu_op = alu_ram;
      STORE_OP:   alu_op = alu_ram;
      I_TYPE_OP:  begin
                    op_b_sel = 2'b01;
                    case(funct3)
                      ADDI_FUNCT:   alu_op = alu_add;
                      SLTI_FUNCT:   alu_op = alu_slt;
                      SLTIU_FUNCT:  alu_op = alu_sltu;
                      SLLI_FUNCT:   alu_op = alu_sll;
                      SRLI_FUNCT:   if(funct7 == SUB_SRA_FUNCT)
                                      	alu_op = alu_sra;
                                    else
                                      	alu_op = alu_srl;
                      XORI_FUNCT:   alu_op = alu_xor;
                      ORI_FUNCT:    alu_op = alu_or;
                      ANDI_FUNCT:   alu_op = alu_and;
                      default:      alu_op = alu_nop;
                    endcase
                  end           
      R_TYPE_OP:  begin
                    op_b_sel = 2'b00;
                    case(funct3)
                      ADD_FUNCT:    if(funct7 == SUB_SRA_FUNCT)
                                      	alu_op = alu_sub;
                                    else
                                      	alu_op = alu_add;
                      SLT_FUNCT:    alu_op = alu_slt;
                      SLTU_FUNCT:   alu_op = alu_sltu;
                      SLL_FUNCT:    alu_op = alu_sll;
                      SRL_FUNCT:    if(funct7 == SUB_SRA_FUNCT)
                                     	 alu_op = alu_sra;
                                    else
                                     	 alu_op = alu_srl;
                      XOR_FUNCT:    alu_op = alu_xor;
                      OR_FUNCT:     alu_op = alu_or;
                      AND_FUNCT:    alu_op = alu_and;
                      default:      alu_op = alu_nop;
                    endcase
                  end
      default:    alu_op = alu_nop;
    endcase
  end

  endmodule
