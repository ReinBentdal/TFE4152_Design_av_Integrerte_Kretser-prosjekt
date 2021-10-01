`include "config.v"
`include "pixelSensor.v"

module PIXEL_ROW(
   input logic      VBN1,
   input logic      RAMP,
   input logic      RESET,
   input logic      ERASE,
   input logic      EXPOSE,
   input logic      READ,
   input logic ENABLE, 
   input [7:0] COUNTER,
   output [PIXEL_ARRAY_WIDTH-1:0][7:0] DATA_OUT
);

    genvar i;
    generate
        for (i = 0; i < PIXEL_ARRAY_WIDTH; i++) begin
            PIXEL_SENSOR ps(
                .VBN1(VBN1),
                .RAMP(RAMP),
                .RESET(RESET),
                .ERASE(ERASE),
                .EXPOSE(EXPOSE),
                .READ(READ),
                .DATA(DATA_OUT[i]),
                .COUNTER(COUNTER)
            );
        end
    endgenerate

endmodule // PIXEL_ROW