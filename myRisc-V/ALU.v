` timescale 1ns/1ps

module ALU
 #(
   parameter DATA_WIDTH = 32,
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
    input  [5 : 0]            alu_code,
    input  [DATA_WIDTH-1 : 0] oprand_a,
    input  [DATA_WIDTH-1 : 0] oprand_b,
    output [DATA_WIDTH-1 : 0] result
  );
  wire [4 : 0] shamt;
  assign shamt = oprand_b[4 : 0];
  always@(*)
  begin
    case(alu_code)
      alu_nop:  result = 32'h0;
      alu_ram:  result = oprand_a + oprand_b;
      alu_add:  result = $signed(oprand_a) + $signed(oprand_b);
      alu_sub:  result = $signed(oprand_a) - $signed(oprand_b);
      alu_slt:  if($signed(oprand_a) < $signed(oprand_b))
                  result = 1;
                else
                  result = 0;
      alu_sltu: if(oprand_a < oprand_b)
                  result = 1;
                else
                  result = 0;
      alu_sll:  result = oprand_a << shamt;
      alu_srl:  result = oprand_a >> shamt;
      alu_sra:  result = $signed(oprand_a) >> shamt;
      alu_xor:  result = oprand_a ^ oprand_b;
      alu_or:   result = oprand_a | oprand_b;
      alu_and:  result = oprand_a & oprand_b;
      default:  result = 32'h0;
    endcase
  end
endmodule

