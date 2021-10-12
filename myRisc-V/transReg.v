module genReg
 #(
   parameter REG_WIDTH = 32
  )
  (
    input                        clk,
    input                        rst,
    input                        en,
    input      [REG_WIDTH-1 : 0] in,
    output reg [REG_WIDTH-1 : 0] out
  );

  always@(posedge clk)
  begin
    if(rst)
      out <= 'h0;
    else
      if(en)
        out <= in;
  end

endmodule


