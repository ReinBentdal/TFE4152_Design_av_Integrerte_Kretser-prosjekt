
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
    wire pixel_frame_finished;

    parameter integer sim_end_max = MAIN_CLK_PERIOD*2400;

    always #MAIN_CLK_PERIOD clk=~clk;
    always #OUTPUT_CLK_PERIOD buffer_clk=~buffer_clk;

    SENSOR_TOP SensorTop(
        .clk(clk),
        .buffer_clk(buffer_clk),
        .output_clk(output_clk),
        .reset(reset),
        .data_out(data_out),
        .pixel_frame_finished(pixel_frame_finished)
    );

    //------------------------------------------------------------
    // WRITE OUTPUT FROM SENSOR_TOP TO FILE
    //------------------------------------------------------------
    integer writeFile = $fopen("image.txt", "w");

    always @( negedge output_clk ) begin
        if (!reset) begin
            for (int i = 0; i < OUTPUT_BUS_WIDTH; i++) begin
                $fdisplay(writeFile, data_out[i]);
            end
        end
    end

    //------------------------------------------------------------
    // READ SCENE TO ARRAY
    //------------------------------------------------------------
    int file;
    reg [8:0] c;
    int index;
    reg [7:0] line;
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

    // end simulation when first image-cycle is finished
    logic pixel_frame_finished_no_x;
    assign pixel_frame_finished_no_x = pixel_frame_finished === 1'bX ? 0 : pixel_frame_finished;

    always @(negedge pixel_frame_finished_no_x) begin
        if (!reset)
            $stop;
    end

//------------------------------------------------------------
// SIMULATION SETUP
//------------------------------------------------------------
    initial begin

        $dumpfile("sensorTop_tb.vcd");
        $dumpvars(0,sensorTop_tb);

        // load the scene to simulate takin a picture
        readScene("scene.txt");

        clk = 0;
        buffer_clk = 0;

        reset = 1;

        #MAIN_CLK_PERIOD reset=0;

        // if simulation doesnt stop elsewhere in the program this prevent the simulation from continuing infinetly
        #sim_end_max
          $stop;
    end

endmodule