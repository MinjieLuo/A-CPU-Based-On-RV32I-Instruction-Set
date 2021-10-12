`timescale 1ns / 1ps
// module IF fetching instruction at the posedge of the clock signal
module IF
#(
        parameter DATA_WIDTH = 32,
        parameter REGADDR_WIDTH = 5
)
(
        input clk,
        input reset,
        input wire [DATA_WIDTH-1 : 0] b_offset_ex,
        input wire [DATA_WIDTH-1 : 0] rs1_data_ex,
        input wire [DATA_WIDTH-1 : 0] jump_offset_ex,
        input wire [DATA_WIDTH-1 : 0] branch_addr,
        input wire [DATA_WIDTH-1 : 0] jr_addr,
        input wire [DATA_WIDTH-1 : 0] jump_addr,
        input flush,
        input pc_en,
        output wire [DATA_WIDTH-1 : 0] instruction_if,
	output wire [DATA_WIDTH-1 : 0] pc_if
);
reg [DATA_WIDTH-1 : 0] pc_pif;
assign branch_addr = pc_if + h_offset_ex;
assign jr_addr     = rs1_data_ex;
assign jump_addr   = pc_if + jump_offset_ex;

always@(*) begin
    if(reset) begin
        pc_pif <= DATA_WIDTH'h200;
    end else begin
        case({j, jr, branch})
            3'b000: pc_pif = pc_if + 4;
            3'b001: pc_pif = branch_addr;
            3'b010: pc_pif = jr_addr;
            3'b100: pc_pif = jump_addr;
            default: pc_pif = 0;
        endcase
end

transReg pc_if (.clk(clk),
              .rst(flush),
              .en(pc_en),
              .in(pc_pif),
              .out(pc_if)); 

ROM rom_if (
	   .clk(clk),
	   .addr(pc_if),
           .instruction(instruction_if));

endmodule
