
`include "sensorTop.v"

`timescale 1 ns / 1 ps

module sensorTop_tb ();
    
    logic reset;
    logic clk;

    parameter integer clk_period = 500;
    parameter integer sim_end = clk_period*4800;

    always #clk_period clk=~clk;

    parameter PIXEL_ARRAY_WIDTH = 128;
    parameter PIXEL_ARRAY_HEIGHT = 128;

    SENSOR_TOP #(
        .PIXEL_ARRAY_WIDTH(PIXEL_ARRAY_WIDTH),
        .PIXEL_ARRAY_HEIGHT(PIXEL_ARRAY_HEIGHT)
    ) SensorTop(
        .clk(clk),
        .reset(reset)
    );

    initial begin

        $dumpfile("sensorTop_tb.vcd");
        $dumpvars(0,sensorTop_tb);

        clk = 0;

        reset = 1;

        #clk_period reset=0;

        #sim_end
          $stop;
    end

endmodule