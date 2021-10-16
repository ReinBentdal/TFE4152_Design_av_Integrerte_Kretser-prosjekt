
`include "sensorTop.v"

`timescale 1 ns / 1 ps

module sensorTop_tb ();
    
    logic reset;
    logic clk;

    parameter integer clk_period = 500;
    parameter integer sim_end = clk_period*2400;

    always #clk_period clk=~clk;

    SENSOR_TOP SensorTop(
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