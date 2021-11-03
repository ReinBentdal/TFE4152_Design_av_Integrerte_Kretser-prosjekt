`include "../pixel_sensor/pixelSensor.sv"
`include "../../pixel_sensor_config.sv"

module PIXEL_ROW(RAMP, ERASE, EXPOSE, READ, COUNTER, DATA_OUT);

    import PixelSensorConfig::PIXEL_ARRAY_WIDTH;
    import PixelSensorConfig::PIXEL_ARRAY_HEIGHT;
    import PixelSensorConfig::PIXEL_BITS;

    input RAMP;
    input ERASE;
    input EXPOSE;
    input READ;
    input [7:0] COUNTER;
    output [PIXEL_ARRAY_WIDTH-1:0][PIXEL_BITS-1:0] DATA_OUT;
    
    parameter row_index = 0;

    genvar i;
    generate
        for (i = 0; i < PIXEL_ARRAY_WIDTH; i++) begin
            PIXEL_SENSOR #(
                .width_index(i),
                .height_index(row_index)
            ) ps(
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