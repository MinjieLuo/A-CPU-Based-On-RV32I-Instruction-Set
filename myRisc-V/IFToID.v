module IFToID
#(
	parameter DATA_WIDTH = 32,
        parameter REGADDR_WIDTH = 5
 )
 (
	input clk,
	input flush,
	input reset,
	input pc_en,
	input wire [DATA_WIDTH-1 : 0] instruction_if,
	input wire [DATA_WIDTH-1 : 0] pc_if,
        output wire [DATA_WIDTH-1 : 0] instruction_id,
	output wire [DATA_WIDTH-1 : 0] pc_id
 );

 reg [DATA_WIDTH : 0] pc_pid;
 reg [DATA_WIDTH : 0] instruction_pid;
 	
 always@(*) begin
	 if(reset) begin
		 pc_pid <= h'0;
		 instruction_pid <= DATA_WIDTH'b0010011;
	 else begin
	 	 pc_pid <= pc_if;
		 instruction_pid <= instruction_if;

 genReg ins_trans(
	 .clk(clk),
 	 .rst(0),
 	 .en(1),
	 .in(instruction_pid)
	 .out(instruction_id)	 
 );
 genReg pc_trans(
	 .clk(clk),
 	 .rst(0),
 	 .en(1),
	 .in(pc_pid)
	 .out(pc_id)	 
 );

 endmodule
 

 

 		
	
	
