`include "../pixel_sensor/pixelSensor.sv"
`include "../../pixel_sensor_config.sv"

module PIXEL_ROW(
   input logic      VBN1,
   input logic      RAMP,
   input logic      ERASE,
   input logic      EXPOSE,
   input logic      READ,
   input [7:0] COUNTER,
   output [PIXEL_ARRAY_WIDTH-1:0][7:0] DATA_OUT
);

    import PixelSensorConfig::PIXEL_ARRAY_WIDTH;

    // photodiode light for each pixel
    parameter [PIXEL_ARRAY_WIDTH-1:0] photodiode_lightintensity_row = {PIXEL_ARRAY_WIDTH{1'b0}};

    genvar i;
    generate
        for (i = 0; i < PIXEL_ARRAY_WIDTH; i++) begin
            PIXEL_SENSOR #(
                .photodiode_lightintensity(photodiode_lightintensity_row[i])
            ) ps(
                .VBN1(VBN1),
                .RAMP(RAMP),
                .ERASE(ERASE),
                .EXPOSE(EXPOSE),
                .READ(READ),
                .DATA(DATA_OUT[i]),
                .COUNTER(COUNTER)
            );
        end
    endgenerate

endmodule // PIXEL_ROW