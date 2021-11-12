`ifndef _GRAYCOUNTER
`define _GRAYCOUNTER

`default_nettype none

module Graycounter(out, clk, reset);

   parameter WIDTH = 8;

   output [WIDTH-1 : 0] out;
   input clk, reset;

   logic [WIDTH-1 : 0]  q;

   assign out = {q[WIDTH-1], q[WIDTH-1:1] ^ q[WIDTH-2:0]};

   always_ff @(posedge clk or posedge reset) begin
      if (reset) begin
        q <= 0;
      end else begin
         q <= q + 1;
      end
   end

endmodule // graycounter

module Graycounter_decode(in, out);

   parameter WIDTH = 8;

   input [WIDTH-1:0] in;
   output logic [WIDTH-1:0] out;

   genvar i;
   generate
      for(i = 0; i < WIDTH; i++) begin
         assign out[i] = ^ in[WIDTH-1:i];
      end
   endgenerate

endmodule

`endif