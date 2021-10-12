`timescale 1ns / 1ns

module RAM
 #(
   localparam ADDR_WIDTH = 32,
   localparam DATA_WIDTH = 32
  )
  ( 
    input                           clk,
    input                           read_en,
    input                           write_en,
    input      [1 : 0]              load_type,
    input      [ADDR_WIDTH-1 : 0]   addr,
    input      [DATA_WIDTH-1 : 0]   data_in,
    output reg [DATA_WIDTH-1 : 0]   data_out
  );
  reg [DATA_WIDTH-1 : 0] ram_buffer [ADDR_WIDTH-1 : 0];

  //read data
  always@(posedge clk)
  begin
    if(read_en)
      case(load_type)
        2'b00: data_out = ram_buffer[addr];//LW
        2'b01: data_out = {{17{ram_buffer[addr][15]}}, ram_buffer[14 : 0]};//LH
        2'b10: data_out = {{26{ram_buffer[addr][7]}}, ram_buffer[6 : 0]};//LB
        default: data_out = 32'h0;
      endcase
  end

  //write data
  always@(posedge clk)
  begin
    if(write_en)
      ram_buffer[addr] = data_in;
  end

endmodule

