`ifdef NETLIST
    `include "output/sensorTop_netlist.v"
`else
    `include "sensorTop.sv"
`endif

`include "../../pixel_sensor_config.sv"

`timescale 1 ns / 1 ps

module sensorTop_tb ();

    import PixelSensorConfig::PIXEL_ARRAY_HEIGHT;
    import PixelSensorConfig::PIXEL_ARRAY_WIDTH;
    import PixelSensorConfig::MAIN_CLK_PERIOD;
    import PixelSensorConfig::OUTPUT_CLK_PERIOD;
    import PixelSensorConfig::PIXEL_BITS;
    import PixelSensorConfig::OUTPUT_BUS_WIDTH;
    import PixelSensorConfig::SCENE;
    import PixelSensorConfig::readScene;
    
    logic reset;
    logic clk;
    logic buffer_clk;
    logic start_read = 0;
    wire output_clk;
    wire [OUTPUT_BUS_WIDTH-1:0][PIXEL_BITS-1:0] data_out;
    wire new_row;
    wire pixel_frame_finished;

    int cycles = 0;

    parameter integer sim_end_max = MAIN_CLK_PERIOD*2400;

    always #MAIN_CLK_PERIOD clk=~clk;
    always #OUTPUT_CLK_PERIOD buffer_clk=~buffer_clk;

    SENSOR_TOP SensorTop(
        .CLK(clk),
        .BUFFER_CLK(buffer_clk),
        .OUTPUT_CLK(output_clk),
        .RESET(reset),
        .DATA_OUT(data_out),
        .FRAME_FINISHED(pixel_frame_finished)
    );

    //------------------------------------------------------------
    // WRITE OUTPUT FROM SENSOR_TOP TO FILE
    //------------------------------------------------------------
    integer writeFile = $fopen("output/image.log", "w");

    always @( posedge output_clk ) begin
        if (!reset & start_read) begin
            for (int i = 0; i < OUTPUT_BUS_WIDTH; i++) begin
                // $display("%0t: %h", $time, data_out[i]);
                $fdisplay(writeFile, data_out[i]);
            end
        end
    end

    // end simulation when first image-cycle is finished
    always @(negedge pixel_frame_finished) begin
        if (!reset && cycles == 1)
            #(14*MAIN_CLK_PERIOD) $stop;
        cycles ++;
    end

//------------------------------------------------------------
// SIMULATION SETUP
//------------------------------------------------------------
    initial begin

        $timeformat(-9, 2, " ns", 20);

        $dumpfile("sensorTop_tb.vcd");
        $dumpvars(0,sensorTop_tb);

        $display("Main clk: %0f", 1.0/MAIN_CLK_PERIOD);
        $display("Output clk: %0f", 1.0/OUTPUT_CLK_PERIOD);

        // load the scene to simulate takin a picture
        readScene("scene_128x128.txt");

        clk = 0;
        buffer_clk = 0;
        reset = 1;

        #MAIN_CLK_PERIOD reset=0;

        #MAIN_CLK_PERIOD start_read = 1;

        // if simulation doesnt stop elsewhere in the program this prevent the simulation from continuing infinetly
        #sim_end_max
          $stop;
    end

endmodule