
`include "../sensor_state/sensorState.v"
`include "../pixel_array/pixelArray.v"

module SENSOR_TOP(
    input clk,
    input reset
);

    parameter PIXEL_ARRAY_WIDTH = 4;
    parameter PIXEL_ARRAY_HEIGHT = 4;

    wire sensor_erase;
    wire sensor_expose;
    wire sensor_expose_clk;
    wire [PIXEL_ARRAY_HEIGHT-1:0] sensor_row_select;
    wire sensor_analog_ramp;
    wire [7:0] sensor_digital_ramp;

    wire [PIXEL_ARRAY_WIDTH-1:0][7:0] data_out;

    PIXEL_ARRAY #(
        .PIXEL_ARRAY_WIDTH(PIXEL_ARRAY_WIDTH),
        .PIXEL_ARRAY_HEIGHT(PIXEL_ARRAY_HEIGHT)
    ) PixelArray(
        .VBN1(sensor_expose_clk),
        .ERASE(sensor_erase),
        .EXPOSE(sensor_expose),
        .READ(sensor_row_select),
        .COUNTER(sensor_digital_ramp),
        .RAMP(sensor_analog_ramp),
        .DATA_OUT(data_out)
    );

    SENSOR_STATE #(
        .PIXEL_ARRAY_WIDTH(PIXEL_ARRAY_WIDTH),
        .PIXEL_ARRAY_HEIGHT(PIXEL_ARRAY_HEIGHT)
    ) SensorState(
        .clk(clk),
        .reset(reset),
        .p_erase(sensor_erase),
        .p_expose(sensor_expose),
        .p_expose_clk(sensor_expose_clk),
        .p_row_select(sensor_row_select),
        .p_aRamp(sensor_analog_ramp),
        .p_dRamp(sensor_digital_ramp)
    );

endmodule