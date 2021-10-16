`include "../pixel_row/pixelRow.v"

module PIXEL_ARRAY(
   input logic      VBN1,
   input logic      RAMP,
   input logic      ERASE,
   input logic      EXPOSE,
   input [PIXEL_ARRAY_HEIGHT-1:0] READ,
   input [7:0] COUNTER,
   output [PIXEL_ARRAY_WIDTH-1:0][7:0] DATA_OUT
);

    parameter PIXEL_ARRAY_HEIGHT = 2;
    parameter PIXEL_ARRAY_WIDTH = 2;

    // TODO: photodiode input scene

    genvar i;
    generate
        for (i = 0; i < PIXEL_ARRAY_HEIGHT; i++) begin
            PIXEL_ROW #(
                // TODO: photodiode input
                .PIXEL_ARRAY_WIDTH(PIXEL_ARRAY_WIDTH)
            ) pr(
                .VBN1(VBN1),
                .RAMP(RAMP),
                .ERASE(ERASE),
                .EXPOSE(EXPOSE),
                .READ(READ[i]),
                .COUNTER(COUNTER),
                .DATA_OUT(DATA_OUT)
            );
        end
    endgenerate

endmodule // PIXEL_ARRAY