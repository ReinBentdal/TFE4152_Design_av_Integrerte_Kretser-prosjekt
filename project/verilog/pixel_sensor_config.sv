
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

    // calculates the clock speed needed to keep up with data from the pixel array
    localparam integer OUTPUT_CLK_PERIOD = $floor(5*MAIN_CLK_PERIOD*OUTPUT_BUS_WIDTH/PIXEL_ARRAY_WIDTH) - 10;

    // logic [3:0][3:0] te  = '{4'b1111, 4'b1111, 4'b1111, 4'b1111};

`ifndef synthesize
    int SCENE [PIXEL_ARRAY_HEIGHT-1:0][PIXEL_ARRAY_WIDTH-1:0];
`endif 

endpackage
`endif