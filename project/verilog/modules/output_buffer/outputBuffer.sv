`default_nettype none

`include "../../pixel_sensor_config.sv"
`include "../../components/counter.sv"
`include "../../components/graycounter.sv"
`include "../../components/register.sv"
`include "../../components/tristate.sv"


// Outputs data from pixel_array to output bus
module OUTPUT_BUFFER

    import PixelSensorConfig::PIXEL_ARRAY_WIDTH;
    import PixelSensorConfig::OUTPUT_BUS_WIDTH;
    import PixelSensorConfig::PIXEL_BITS;
    
(
    input SET_BUFFER,
    input RESET,
    input CLK,
    input [PIXEL_ARRAY_WIDTH-1:0][PIXEL_BITS-1:0] DATA_IN,
    output logic OUTPUT_CLK,
    output logic [(OUTPUT_BUS_WIDTH*PIXEL_BITS)-1:0] DATA_OUT
);


    parameter integer counter_bits = $rtoi($ceil($clog2(PIXEL_ARRAY_WIDTH/OUTPUT_BUS_WIDTH)));
    parameter integer counter_cycles = (PIXEL_ARRAY_WIDTH/OUTPUT_BUS_WIDTH) - 1;

    //------------------------------------------------------------
    // Graycounter decode
    //------------------------------------------------------------    
    wire [PIXEL_ARRAY_WIDTH-1:0][PIXEL_BITS-1:0] data_in_decode;

    Graycounter_decode #(.WIDTH(PIXEL_BITS)) decoder[PIXEL_ARRAY_WIDTH-1:0] (
        .in(DATA_IN),
        .out(data_in_decode)
    );

    //------------------------------------------------------------
    // Internal counter to track shifting progress
    //------------------------------------------------------------
    logic sending_data;
    logic counter_reset;
    wire [counter_bits-1:0] counter_out;

    Counter #(
        .bits(counter_bits)
    ) Counter(
        .clk(CLK),
        .reset(counter_reset | RESET),
        .enable(sending_data),
        .out(counter_out)
    );

    //------------------------------------------------------------
    // Data shift register 
    //------------------------------------------------------------
    logic should_shift;

    // only used for simulations
    logic shift; 
    assign shift = should_shift & CLK;

    logic set_register;
    wire [(OUTPUT_BUS_WIDTH*PIXEL_BITS)-1:0] local_data_out;

    wire set_select;
    assign set_select = new_input | (set_register & CLK);

    RegisterShifter #(
        .bits(PIXEL_BITS*OUTPUT_BUS_WIDTH), 
        .length(PIXEL_ARRAY_WIDTH/OUTPUT_BUS_WIDTH)
    ) DataBuffer(
        .set(set_register & CLK),
        .set_select(set_select),
        .reset(RESET),
        .shift(CLK & should_shift),
        .data_in(data_in_decode),
        .data_out(local_data_out)
    );


    //------------------------------------------------------------
    // COMB to  bridge between two clock frequencies
    //------------------------------------------------------------
    logic new_input;

    always_comb begin
        if (SET_BUFFER & ~sending_data) begin
            new_input = 1;
        end
        else begin
            new_input = 0;
        end
    end

    //------------------------------------------------------------
    // State machine
    //------------------------------------------------------------
    always_ff @(posedge CLK or posedge RESET) begin

        if (RESET) begin
            sending_data <= 0;
            counter_reset <= 0;   
            should_shift <= 0;
            set_register <= 0;
        end
        else begin
            
            if (sending_data) begin
                should_shift <= 1;
            end

            if (counter_reset) begin
                counter_reset <= 0;
            end

            if (new_input) begin
                sending_data <= 1;
                set_register <= 1;
            end

            if (set_register) begin
                set_register <= 0;
            end
            else begin

                if (counter_out == counter_cycles) begin
                    counter_reset <= 1;
                    sending_data <= 0;
                    should_shift <= 0;
                end
                
            end
        end
    end

    //------------------------------------------------------------
    // OUTPUT
    //------------------------------------------------------------
    assign OUTPUT_CLK = sending_data ? ~CLK : 0;

    Tristate Tristate [(OUTPUT_BUS_WIDTH*PIXEL_BITS)-1:0] (
        .A(local_data_out),
        .EN(sending_data),
        .Y(DATA_OUT)
    );


endmodule