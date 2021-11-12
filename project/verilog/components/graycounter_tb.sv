`include "graycounter.sv"

module graycounter_tb;

    localparam CLK_PERIOD = 500;
    localparam SIM_END_MAX = 1000*CLK_PERIOD;

    logic clk;
    logic reset;
    logic [7:0] out;
    logic [7:0] decode_out;

    always #CLK_PERIOD clk = ~clk;

    Graycounter #(.WIDTH(8)) counter(
        .reset(reset),
        .clk(clk),
        .out(out)
    );

    Graycounter_decode #(.WIDTH(8)) counter_decode(
        .in(out),
        .out(decode_out)
    );

    initial begin

        $dumpfile("output/graycounter_tb.vcd");
        $dumpvars(0,graycounter_tb);

        clk = 0;
        reset = 1;

        #CLK_PERIOD reset=0;


        // if simulation doesnt stop elsewhere in the program this prevent the simulation from continuing infinetly
        #SIM_END_MAX
          $stop;
    end

endmodule