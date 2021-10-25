
`default_nettype none

`ifndef _PIXEL_SENSOR_CONFIG
`define _PIXEL_SENSOR_CONFIG
package PixelSensorConfig;

    localparam integer PIXEL_ARRAY_HEIGHT = 128;
    localparam integer PIXEL_ARRAY_WIDTH = 128;
    localparam PIXEL_BITS = 8;
    
    // number of pixels read each clock cycle
    localparam OUTPUT_BUS_WIDTH = 8;

    localparam MAIN_CLK_PERIOD = 500;

    // calculates the clock speed needed to keep up with data from the pixel array.
    // 1 extra output buffer clk for each clk to compensate for clock offset.
    localparam real _CLK_RATIO = real'(PIXEL_ARRAY_WIDTH)/real'(OUTPUT_BUS_WIDTH) + 1;
    localparam integer OUTPUT_CLK_PERIOD = $floor(real'(5*MAIN_CLK_PERIOD)/_CLK_RATIO);

`ifndef synthesize
    int SCENE [PIXEL_ARRAY_HEIGHT-1:0][PIXEL_ARRAY_WIDTH-1:0];
`endif 

endpackage
`endif