// `define RUN_NETLIST

`ifdef RUN_NETLIST
    `include "sensorState_netlist.sv"
`else
    `include "sensorState.sv"
`endif

`timescale 1 ns / 1 ps

module sensorState_tb ();

    import PixelSensorConfig::PIXEL_ARRAY_HEIGHT;
    import PixelSensorConfig::PIXEL_ARRAY_WIDTH;
    import PixelSensorConfig::PIXEL_BITS;
    import PixelSensorConfig::MAIN_CLK_PERIOD;

    logic clk;
    logic reset;

    parameter integer sim_end = MAIN_CLK_PERIOD*2400;

    always #MAIN_CLK_PERIOD clk=~clk;

    wire p_erase;
    wire p_expose_clk;
    wire p_expose;
    wire [PIXEL_ARRAY_HEIGHT-1:0] p_row_select;
    wire [PIXEL_BITS-1:0] p_dRamp;

    SENSOR_STATE sensor(
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

        #MAIN_CLK_PERIOD reset=0;

        #sim_end
          $stop;
    end

endmodule