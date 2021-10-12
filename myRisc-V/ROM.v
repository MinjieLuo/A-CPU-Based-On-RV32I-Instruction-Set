`timescale 1ns / 1ps

module ROM
 #(
   parameter INS_WIDTH = 32
  )
  (
   input clk,
   input [31 : 0] addr,
   output reg [INS_WIDTH-1 : 0] instruction
  );
  reg [INS_WIDTH-1 : 0] rom_buffer [31 : 0];

  always@(posedge clk)
  begin	
  	instruction = rom_buffer[addr];
  end
  
endmodule

