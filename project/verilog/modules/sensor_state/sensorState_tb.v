// `define RUN_NETLIST

`include "../../components/shifter.v"
`include "../../components/counter.v"

`ifdef RUN_NETLIST
    `include "sensorState_netlist.v"
`else
    `include "sensorState.v"
`endif

`timescale 1 ns / 1 ps

module sensorState_tb ();

    parameter PIXEL_ARRAY_HEIGHT = 4;
    parameter PIXEL_ARRAY_WIDTH = 4;

    logic clk;
    logic reset;

    parameter integer clk_period = 50;
    parameter integer sim_end = clk_period*2400;

    always #clk_period clk=~clk;

    wire p_erase;
    wire p_expose_clk;
    wire p_expose;
    wire [PIXEL_ARRAY_HEIGHT-1:0] p_row_select;
    wire [7:0] p_dRamp;

    SENSOR_STATE #(
        .PIXEL_ARRAY_WIDTH(PIXEL_ARRAY_WIDTH),
        .PIXEL_ARRAY_HEIGHT(PIXEL_ARRAY_HEIGHT)
    ) sensor(
        .clk(clk),
        .reset(reset),
        .p_erase(p_erase),
        .p_expose_clk(p_expose_clk),
        .p_expose(p_expose),
        .p_row_select(p_row_select),
        .p_dRamp(p_dRamp)
    );

    initial begin

        $dumpfile("sensorState_tb.vcd");
        $dumpvars(0,sensorState_tb);

        clk = 0;

        reset = 1;

        #clk_period reset=0;

        #sim_end
          $stop;
    end

endmodule