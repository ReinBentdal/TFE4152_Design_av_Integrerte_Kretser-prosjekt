
`default_nettype none

`ifndef _PIXEL_SENSOR_CONFIG
`define _PIXEL_SENSOR_CONFIG

`timescale 1 ns / 1 ps

package PixelSensorConfig;

    `ifdef PIXEL_HEIGHT
    localparam integer PIXEL_ARRAY_HEIGHT = `PIXEL_HEIGHT;
    `else
    localparam integer PIXEL_ARRAY_HEIGHT = 12;
    `endif

    `ifdef PIXEL_WIDTH
    localparam integer PIXEL_ARRAY_WIDTH = `PIXEL_WIDTH;
    `else
    localparam integer PIXEL_ARRAY_WIDTH = 24;
    `endif

    // register size in pixel
    localparam PIXEL_BITS = 8;
    
    // number of pixels read each clock cycle
    localparam OUTPUT_BUS_WIDTH = 8;

    // The clock at which SENSOR_STATE operates at
    localparam MAIN_CLK_PERIOD = 500;

    // calculates the clock speed needed to keep up with data from the pixel array.
    // 2 extra output_clk  cycle for each row to compensate for clock offset between clk and output_clk.
    localparam integer OUTPUT_CLK_PERIOD = $floor((5*MAIN_CLK_PERIOD)/((PIXEL_ARRAY_WIDTH)/(OUTPUT_BUS_WIDTH) + 1));

    // image scene for simulation. Has to by 1D packed array because of yosys constrains
    parameter logic [(8*(16*16))-1:0] SCENE_16 = 2048'b11001110110011001101000011010011110011111100110010111101101100111001111001111110011010101000001110100011110000011011010011000001110100111100110111000011110000011011100010101111100111011000001101110101010110110110001110001110100010101000011001100011011101110011101001000101001110010011010000111011010000010111000101001001010100100101011001010010010011010101010100101111000111100001101001011010010110010100001000111010010011000111100010000010100000111001100101110110010100110100110001010100001100100010011000100001010101100011110100111000010001111000110010100100101010111011001110111011011110100111001101100011001100010011010000101110001011000100000000110101001110001000001010101100101110001100011010111111011111110100111101010000011000100101010100110110001101000011010101000001001111000011111110011100101111001100100111001110011011000101100001100110011110111000001100111110001110010011010000110111010011010100010101001110100001111100111011010010100111110110011001101110100001001001111101010010010001000011110100110101001101000101100001010001010110000110011010110000100101000111010001110000011100111001000001101100010010110100011000111110001100110011010001010110010101000101010001100001011111111001000110000110011110011000101001111000010011110101000001001010010000000011011100111000010101000101101001100011010010000111001010001100100011001001001101111011010101100101011001010101010101000100111001000110010001000101011001110011101101110100011110000011100000101001010001111110010111110101110001011011010110000101011001010001010010100100011001011100010111110110011001110010100110101010101110000101011000100110001001011101010111010101100101001111010001110100000000111011010101110101101001011001010111100110001001101001011000110101101001011000010100000101000001001101010000010011010100110001001011110100011101001000010010010101000001010101011000000101111001010001010010010011110000111111001111010011001000100111001001010010010100111101001111000011110001000101010011100101110001011101010100000100010000110100001101100011011000101110001001100010011000100110;
    parameter logic [(8*24*24)-1:0] SCENE_24 = 4608'b110000001011110111000100110010001100100011000001110000001100000110111110101101011011001010101010100110111000110101111010011000110110101001111010100011011010111010111111101111001010000010111111111011111110100011101001111010011110111111110001111011101110011011011001101111111011110010110110101001101000101001110101011011101000111110101101101110011100110011010001101001001100000111001111110001001011100110110100101010001010000110100001100101111000110010011011100110110111001101101110010111110101001101000110010011000110001001111100010110100100101000101111001001010001110000010111001101100011011100111110001101010011000000110010001101110011101100111110011101010110011001000001010010000101001101010010010011110101011101001110010110110011011100110000001000000001101000011010010001100101010101010111010001110011101000111010010000010100011001011001011010000110010001010010011001100110110001011001010110000100101001000101010110000100001100110000001000110001110100011100010111110101101001010110010001000011101100111010010001010110101110000111100010011000100110010110101010011001111101110001010101110100000101010111010110100011101000101110001010010010010100100010010111010100111100111100001101010011111001000001011101111001010110100010101001001010100110110001110001001010101001101010011011000111000001100101001010100011001100110000001011010010110000101000010100010011101100110100001101100011111001101110101000111010011110101111101101111011101110111110101100111000001001100011011001010110010001001000010010010100110100110101001100100011010000110010001111110011010100110101001101100011110010100000101010111011010011000001110010001100111110110010011011100100001001001001010101000101100001110100010101110011011000110110001100110011010100110100010000010011101100111011001111000100011010110001101110011100000111001101110101111011001001010100010011110101101101100101011010011000010110000110001111100011100100111000001100110011010000110111010010010100010001000000001111110100101110110000110010001011101111010001110011011000100001011100010111100110100001110101100011011010001001001110010001000011111000111011001101110011010000110111010100000100100101000101010010010101101110001001110011101101010111010000100111010110100101100111011011011000000010001111101001010110110001001011010001100100000100111100001101100011000100110100010110100101001101001110010011010110011001101100101110001100011010001011011100100110111001101111011100000111110010011000100001110100100101001011010001110100000100111100001101000011001000110101010110010101011101010011010100010110100101011000100000101000100010000010100000000111100001110000011100111000011010001101010011110100101101001101010010010100001100111100001101000011001000110101010101010101010001010100010101100101100001011110011101001001000110010010100010100111111101111101100011001001010001011010010100000101000101010001010011100100011001000000001110010011011100111010010101010101001101010110010110100101010101000110010111011000110110001101100011011000110110010011100100110101111101010011010101000101010001010101010101000100111001001100010001010100001001000011010100110101011010001001100011100111010101000010010111001000111101111111100001111001001010010001010111100101101001011010010110100101011001010111010101110101001101010010010011000100011001000111010101110101101001100100110000101001010101000100011101101001000110000010100100101001110101100011011000010101111101011100010111010101101001011000010101110101001001010000010010110100011001000110010110110101110001100000011001000111001101101111100001001001101110110001101000000110100101100001011000100110000101011100010111100101101101011001010100100100110101001000010000110011111000111110010111000101111001011111011000010110010001101101100000001001101110000110011001000110001101011110010111110101111001010111010110000101100001010011010010110100001000111110001110010011010100110110010100110101011101011000010101010101011101011011010111010110010001101000011000110101111001010101010101010101000101001001010011000100110001001001010000010011010100110000001011110010110000101101010010010100101101001011010010110100110101010011010101100101110101100001011000000101101001001111010011010100010100111101010000110100001000111111001101110010101100100111001001110010010100100111001111100011111000111110010000000100001101001010010011010101011101011100010111100101100001001001010001010011110000110010001101100011100000110101001011110010011000100100001001000010001100100101001111010011110000111100001111000011111101000111010011010101011101011101010111110101101001001100010010000011111000110011001101100011011100110101001100010010100100100111001001110010010100101000;

    // for larger scenes, the scene has to be imported "just in time" due to size constraints.
    int SCENE [PIXEL_ARRAY_HEIGHT-1:0][PIXEL_ARRAY_WIDTH-1:0];
    int file;
    logic [8:0] c;
    int index;
    logic [7:0] line;
    int pixel_value;
    int line_index;
    int width_index;
    int height_index;

    // fill SCENE parameter with values from file
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

endpackage
`endif