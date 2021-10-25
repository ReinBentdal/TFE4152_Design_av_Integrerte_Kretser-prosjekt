`include "../../pixel_sensor_config.sv"
`include "../pixel_row/pixelRow.sv"

module PIXEL_ARRAY(
   input logic      VBN1,
   input logic      RAMP,
   input logic      ERASE,
   input logic      EXPOSE,
   input [PIXEL_ARRAY_HEIGHT-1:0] READ,
   input [7:0] COUNTER,
   output [PIXEL_ARRAY_WIDTH-1:0][PIXEL_BITS-1:0] DATA_OUT
);

    import PixelSensorConfig::PIXEL_ARRAY_HEIGHT;
    import PixelSensorConfig::PIXEL_ARRAY_WIDTH;
    import PixelSensorConfig::PIXEL_BITS;

    genvar i;
    generate
        for (i = 0; i < PIXEL_ARRAY_HEIGHT; i++) begin
            PIXEL_ROW #(
                .row_index(i)
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