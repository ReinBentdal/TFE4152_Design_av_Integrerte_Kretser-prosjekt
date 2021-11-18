

`include "outputBuffer.sv"
`include "../../pixel_sensor_config.sv"

// simple output buffer test. Mainly tested with data from pixel array since this results in nice images
module outputBuffer_tb;
    
    import PixelSensorConfig::OUTPUT_CLK_PERIOD;
    import PixelSensorConfig::PIXEL_ARRAY_WIDTH;
    import PixelSensorConfig::PIXEL_BITS;
    import PixelSensorConfig::OUTPUT_BUS_WIDTH;

    localparam sim_end = OUTPUT_CLK_PERIOD*500;
    
    logic clk = 0;
    always #OUTPUT_CLK_PERIOD clk = ~clk;
    
    logic reset = 0;

    logic [PIXEL_ARRAY_WIDTH-1:0][PIXEL_BITS-1:0] data_in;

    logic set_buffer  = 0;

    wire output_clk;
    wire [(OUTPUT_BUS_WIDTH*PIXEL_BITS)-1:0] data_out;

    OUTPUT_BUFFER  buffer(
        .SET_BUFFER(set_buffer),
        .RESET(reset),
        .CLK(clk),
        .DATA_IN(data_in),
        .OUTPUT_CLK(output_clk),
        .DATA_OUT(data_out)     
    );


    initial begin

        for (int i = 0; i < PIXEL_ARRAY_WIDTH; i++) begin
            data_in[i] = i;
        end

        $dumpfile("output/outputBuffer_tb.vcd");
        $dumpvars(0,outputBuffer_tb);
        
        reset = 1;

        #OUTPUT_CLK_PERIOD  reset=0;

        #OUTPUT_CLK_PERIOD set_buffer = 1;
        #OUTPUT_CLK_PERIOD set_buffer = 0;

        #sim_end
          $stop;
    end

endmodule