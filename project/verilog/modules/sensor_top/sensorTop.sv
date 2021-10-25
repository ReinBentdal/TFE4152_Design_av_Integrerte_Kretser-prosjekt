`include "../../pixel_sensor_config.sv"
`include "../sensor_state/sensorState.sv"
`include "../pixel_array/pixelArray.sv"
`include "../output_buffer/outputBuffer.sv"

module SENSOR_TOP(
    input clk,
    input reset,
    input buffer_clk,
    output output_clk,
    output [OUTPUT_BUS_WIDTH-1:0][PIXEL_BITS-1:0] data_out
);

    import PixelSensorConfig::PIXEL_ARRAY_HEIGHT;
    import PixelSensorConfig::PIXEL_ARRAY_WIDTH;
    import PixelSensorConfig::OUTPUT_BUS_WIDTH;
    import PixelSensorConfig::PIXEL_BITS;

    wire sensor_erase;
    wire sensor_expose;
    wire sensor_expose_clk;
    wire [PIXEL_ARRAY_HEIGHT-1:0] sensor_row_select;
    wire sensor_new_row;
    wire sensor_analog_ramp;
    wire [7:0] sensor_digital_ramp;
    wire [PIXEL_ARRAY_WIDTH-1:0][7:0] sensor_data_out;

    PIXEL_ARRAY PixelArray(
        .VBN1(sensor_expose_clk),
        .ERASE(sensor_erase),
        .EXPOSE(sensor_expose),
        .READ(sensor_row_select),
        .COUNTER(sensor_digital_ramp),
        .RAMP(sensor_analog_ramp),
        .DATA_OUT(sensor_data_out)
    );

    SENSOR_STATE SensorState(
        .clk(clk),
        .reset(reset),
        .p_erase(sensor_erase),
        .p_expose(sensor_expose),
        .p_expose_clk(sensor_expose_clk),
        .p_row_select(sensor_row_select),
        .new_row(sensor_new_row),
        .p_aRamp(sensor_analog_ramp),
        .p_dRamp(sensor_digital_ramp)
    );

    OUTPUT_BUFFER OutputBuffer(
        .set(sensor_new_row),
        .reset(reset),
        .clk(buffer_clk),
        .data_inn(sensor_data_out),
        .output_clk(output_clk),
        .data_out(data_out)
    );

endmodule