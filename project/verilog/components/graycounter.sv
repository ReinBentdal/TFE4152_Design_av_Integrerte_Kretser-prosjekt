module graycounter(out, clk, reset);

   parameter WIDTH = 8;

   output [WIDTH-1 : 0] out;
   input                clk, reset;

   logic [WIDTH-1 : 0]  out;
   wire                 clk, reset;

   logic [WIDTH-1 : 0]  q;


   always @(posedge clk or posedge reset) begin
      if (reset)
        q <= 0;
      else begin
         q <= q + 1;
      end
      out <= {q[WIDTH-1], q[WIDTH-1:1] ^ q[WIDTH-2:0]};
   end

endmodule // graycounter

module graycounter_decode(in, out);

   parameter WIDTH = 4;

   input [WIDTH-1:0] in;
   output logic [WIDTH-1:0] out;

   genvar i;
   generate
      // genvar bit [WIDTH-1:0] tmp;
      for(i = 0; i < 2 ** WIDTH; i++) begin
         always_comb begin
            logic [WIDTH-1:0] tmp = WIDTH'(i);
            if (in == {tmp[WIDTH-1], tmp[WIDTH-1:1] ^ tmp[WIDTH-2:0]}) begin
               out = tmp;
            end
         end
      end
   endgenerate

endmodule