
`default_nettype none

`ifndef _PIXEL_SENSOR_CONFIG
`define _PIXEL_SENSOR_CONFIG

`timescale 1 ns / 1 ps

package PixelSensorConfig;

    localparam integer PIXEL_ARRAY_HEIGHT = 3;
    localparam integer PIXEL_ARRAY_WIDTH = 24;
    localparam PIXEL_BITS = 8;
    
    // number of pixels read each clock cycle
    localparam OUTPUT_BUS_WIDTH = 8;

    localparam MAIN_CLK_PERIOD = 500;

    // calculates the clock speed needed to keep up with data from the pixel array.
    // 2 extra output_clk  cycle for each row to compensate for clock offset between clk and output_clk.
    localparam integer OUTPUT_CLK_PERIOD = $floor((5*MAIN_CLK_PERIOD)/((PIXEL_ARRAY_WIDTH)/(OUTPUT_BUS_WIDTH) + 1));

`ifndef synthesize
    int SCENE [PIXEL_ARRAY_HEIGHT-1:0][PIXEL_ARRAY_WIDTH-1:0];

    int file;
    logic [8:0] c;
    int index;
    logic [7:0] line;
    int pixel_value;
    int line_index;
    int width_index;
    int height_index;

    task readScene(string filename);
        $display("FILE READ START");
        
        file = $fopen(filename, "r");

        while (!$feof(file)) begin
            $fscanf(file,"%d\n",line);
            pixel_value = line;

            width_index = line_index % PIXEL_ARRAY_WIDTH;
            height_index = line_index/PIXEL_ARRAY_WIDTH;

            SCENE[height_index][width_index] = pixel_value;

            line_index++;
        end

        $display("FILE READ FINISHED");

        $fclose(file);
    endtask
`endif 

endpackage
`endif