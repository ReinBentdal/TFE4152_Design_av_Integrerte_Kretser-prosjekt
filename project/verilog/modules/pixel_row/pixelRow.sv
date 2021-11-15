`include "../pixel_sensor/pixelSensor.sv"
`include "../../pixel_sensor_config.sv"

module PIXEL_ROW

    import PixelSensorConfig::PIXEL_ARRAY_WIDTH;
    import PixelSensorConfig::PIXEL_ARRAY_HEIGHT;
    import PixelSensorConfig::PIXEL_BITS;

(
    input ANALOG_RAMP, 
    input ERASE, 
    input EXPOSE, 
    input READ, 
    input [PIXEL_BITS-1:0] DIGITAL_RAMP, 
    output [PIXEL_ARRAY_WIDTH-1:0][PIXEL_BITS-1:0] DATA_OUT
);
    
    parameter row_index = 0;

    genvar i;
    generate
        for (i = 0; i < PIXEL_ARRAY_WIDTH; i++) begin
            PIXEL_SENSOR #(
                .width_index(i),
                .height_index(row_index)
            ) ps(
                .ANALOG_RAMP(ANALOG_RAMP),
                .ERASE(ERASE),
                .EXPOSE(EXPOSE),
                .READ(READ),
                .DATA(DATA_OUT[i]),
                .DIGITAL_RAMP(DIGITAL_RAMP)
            );
        end
    endgenerate

endmodule // PIXEL_ROW