`include "../../pixel_sensor_config.sv"
`include "../pixel_row/pixelRow.sv"

module PIXEL_ARRAY(ANALOG_RAMP, ERASE, EXPOSE, READ, DIGITAL_RAMP, DATA_OUT);

    import PixelSensorConfig::PIXEL_ARRAY_HEIGHT;
    import PixelSensorConfig::PIXEL_ARRAY_WIDTH;
    import PixelSensorConfig::PIXEL_BITS;

    input ANALOG_RAMP;
    input ERASE;
    input EXPOSE;
    input [PIXEL_ARRAY_HEIGHT-1:0] READ;
    input [7:0] DIGITAL_RAMP;
    output [PIXEL_ARRAY_WIDTH-1:0][PIXEL_BITS-1:0] DATA_OUT;

    genvar i;
    generate
        for (i = 0; i < PIXEL_ARRAY_HEIGHT; i++) begin
            PIXEL_ROW #(
                .row_index(i)
            ) pr(
                .ANALOG_RAMP(ANALOG_RAMP),
                .ERASE(ERASE),
                .EXPOSE(EXPOSE),
                .READ(READ[i]),
                .DIGITAL_RAMP(DIGITAL_RAMP),
                .DATA_OUT(DATA_OUT)
            );
        end
    endgenerate

endmodule // PIXEL_ARRAY