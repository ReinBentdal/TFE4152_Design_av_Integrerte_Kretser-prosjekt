`include "../pixel_sensor/pixelSensor.v"

module PIXEL_ROW(
   input logic      VBN1,
   input logic      RAMP,
   input logic      RESET,
   input logic      ERASE,
   input logic      EXPOSE,
   input logic      READ,
   input [7:0] COUNTER,
   output [PIXEL_ARRAY_WIDTH-1:0][7:0] DATA_OUT
);

    parameter PIXEL_ARRAY_WIDTH = 2;
    parameter integer dv_row = 1;

    genvar i;
    generate
        for (i = 0; i < PIXEL_ARRAY_WIDTH; i++) begin
            PIXEL_SENSOR #(.dv_pixel(i*0.02*dv_row)) ps(
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