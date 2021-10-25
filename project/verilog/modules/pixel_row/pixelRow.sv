`include "../pixel_sensor/pixelSensor.sv"
`include "../../pixel_sensor_config.sv"

module PIXEL_ROW(
   input logic      VBN1,
   input logic      RAMP,
   input logic      ERASE,
   input logic      EXPOSE,
   input logic      READ,
   input [7:0] COUNTER,
   output [PIXEL_ARRAY_WIDTH-1:0][PIXEL_BITS-1:0] DATA_OUT
);

    import PixelSensorConfig::PIXEL_ARRAY_WIDTH;
    import PixelSensorConfig::PIXEL_ARRAY_HEIGHT;
    import PixelSensorConfig::PIXEL_BITS;
    // import PixelSensorConfig::SCENE;
    
    parameter row_index = 0;

    genvar i;
    generate
        for (i = 0; i < PIXEL_ARRAY_WIDTH; i++) begin
            // int px_value = SCENE[row_index][i];
            // real px_value_real = px_value/255;
            PIXEL_SENSOR #(
                // .photodiode_lightintensity(px_value_real)
                .width_index(i),
                .height_index(row_index)
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