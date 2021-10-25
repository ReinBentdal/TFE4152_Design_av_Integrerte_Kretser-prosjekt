
`include "sensorTop.sv"

`timescale 1 ns / 1 ps

module sensorTop_tb ();

    import PixelSensorConfig::PIXEL_ARRAY_HEIGHT;
    import PixelSensorConfig::PIXEL_ARRAY_WIDTH;
    import PixelSensorConfig::MAIN_CLK_PERIOD;
    import PixelSensorConfig::OUTPUT_CLK_PERIOD;
    import PixelSensorConfig::PIXEL_BITS;
    import PixelSensorConfig::OUTPUT_BUS_WIDTH;
    import PixelSensorConfig::SCENE;
    
    logic reset;
    logic clk;
    logic buffer_clk;
    wire output_clk;
    wire [OUTPUT_BUS_WIDTH-1:0][PIXEL_BITS-1:0] data_out;
    wire new_row;

    parameter integer sim_end = MAIN_CLK_PERIOD*2400;

    always #MAIN_CLK_PERIOD clk=~clk;
    always #OUTPUT_CLK_PERIOD buffer_clk=~buffer_clk;

    SENSOR_TOP SensorTop(
        .clk(clk),
        .buffer_clk(buffer_clk),
        .output_clk(output_clk),
        .reset(reset),
        .data_out(data_out)
    );

    integer writeFile = $fopen("image.txt", "w");

    always @( posedge output_clk ) begin
        if (!reset) begin
            for (int i = 0; i < OUTPUT_BUS_WIDTH; i++) begin
                $fdisplay(writeFile, data_out[i]);
            end
        end
    end

    int file;
    reg [8:0] c;
    int index;
    reg [7:0] line;
    int pixel_value;
    int line_index;
    int width_index;
    int height_index;


    initial begin

        $dumpfile("sensorTop_tb.vcd");
        $dumpvars(0,sensorTop_tb);

        $display("FILE READ START");

        file = $fopen("scene.txt", "r");

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

        clk = 0;
        buffer_clk = 0;

        reset = 1;

        #MAIN_CLK_PERIOD reset=0;

        #sim_end
          $stop;
    end

endmodule