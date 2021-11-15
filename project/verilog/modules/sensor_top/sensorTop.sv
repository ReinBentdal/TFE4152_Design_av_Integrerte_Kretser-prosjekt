// `define synthesize

`include "../../pixel_sensor_config.sv"
`include "../sensor_state/sensorState.sv"
`include "../pixel_array/pixelArray.sv"
`include "../output_buffer/outputBuffer.sv"

// wiring together the individual modules of the final sensor
module SENSOR_TOP

    import PixelSensorConfig::PIXEL_ARRAY_HEIGHT;
    import PixelSensorConfig::PIXEL_ARRAY_WIDTH;
    import PixelSensorConfig::OUTPUT_BUS_WIDTH;
    import PixelSensorConfig::PIXEL_BITS;

(
    input CLK,
    input RESET,
    input BUFFER_CLK,
    output OUTPUT_CLK,
    output [OUTPUT_BUS_WIDTH-1:0][PIXEL_BITS-1:0] DATA_OUT,
    output FRAME_FINISHED
);

    wire sensor_erase;
    wire sensor_expose;
    wire [PIXEL_ARRAY_HEIGHT-1:0] sensor_row_select;
    wire sensor_new_row;
    wire sensor_analog_ramp;
    wire [7:0] pixel_digital_ramp;
    wire [PIXEL_ARRAY_WIDTH-1:0][7:0] sensor_data_out;

    PIXEL_ARRAY PixelArray(
        .ERASE(sensor_erase),
        .EXPOSE(sensor_expose),
        .READ(sensor_row_select),
        .DIGITAL_RAMP(pixel_digital_ramp),
        .ANALOG_RAMP(sensor_analog_ramp),
        .DATA_OUT(sensor_data_out)
    );

    SENSOR_STATE SensorState(
        .CLK(CLK),
        .RESET(RESET),
        .PIXEL_ERASE(sensor_erase),
        .PIXEL_EXPOSE(sensor_expose),
        .SENSOR_ROW_SELECT(sensor_row_select),
        .NEW_ROW(sensor_new_row),
        .PIXEL_ANALOG_RAMP(sensor_analog_ramp),
        .PIXEL_DIGITAL_RAMP(pixel_digital_ramp),
        .FRAME_FINISHED(FRAME_FINISHED)
    );

    OUTPUT_BUFFER OutputBuffer(
        .SET_BUFFER(sensor_new_row),
        .RESET(RESET),
        .CLK(BUFFER_CLK),
        .DATA_IN(sensor_data_out),
        .OUTPUT_CLK(OUTPUT_CLK),
        .DATA_OUT(DATA_OUT)
    );

endmodule