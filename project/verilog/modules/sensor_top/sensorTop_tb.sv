
`include "sensorTop.sv"

`timescale 1 ns / 1 ps

module sensorTop_tb ();
    
    logic reset;
    logic clk;

    parameter integer clk_period = 500;
    parameter integer sim_end = clk_period*4800;

    always #clk_period clk=~clk;

    parameter PIXEL_ARRAY_WIDTH = 3;
    parameter PIXEL_ARRAY_HEIGHT = 3;

    SENSOR_TOP #(
        .PIXEL_ARRAY_WIDTH(PIXEL_ARRAY_WIDTH),
        .PIXEL_ARRAY_HEIGHT(PIXEL_ARRAY_HEIGHT)
    ) SensorTop(
        .clk(clk),
        .reset(reset)
    );

    integer file;
    reg [8:0] c;
    byte      q[$];
    int       i;
    int line;

    initial begin

        $dumpfile("sensorTop_tb.vcd");
        $dumpvars(0,sensorTop_tb);


        file = $fopen("scene.txt", "r");
        c = $fgetc(file);
        while (c != 'h1ff) begin
            q.push_back(c);
            if (c == 'ha) begin
                i = 0;
                line++;
            end
            else
                $display("Got char index [%0d], line [%0d] 0x%0h", i++, line, c);
            c = $fgetc(file);
        end

        clk = 0;

        reset = 1;

        #clk_period reset=0;

        #sim_end
          $stop;
    end

endmodule