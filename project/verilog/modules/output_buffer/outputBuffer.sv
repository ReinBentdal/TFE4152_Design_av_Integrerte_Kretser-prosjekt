`default_nettype none

`include "../../pixel_sensor_config.sv"
`include "../../components/counter.sv"
`include "../../components/register.sv"
`include "../../components/tristate.sv"

/*
Because the module has inputs from two different clock cycles, there needs to be enough delay, from InputDelay, to "bridge" between two different clock cycles.

*/
module OUTPUT_BUFFER(
    input SET_BUFFER,
    input RESET,
    input CLK,
    input [PIXEL_ARRAY_WIDTH-1:0][PIXEL_BITS-1:0] DATA_IN,
    output logic OUTPUT_CLK,
    output logic [(OUTPUT_BUS_WIDTH*PIXEL_BITS)-1:0] DATA_OUT
);

    import PixelSensorConfig::PIXEL_ARRAY_WIDTH;
    import PixelSensorConfig::OUTPUT_BUS_WIDTH;
    import PixelSensorConfig::PIXEL_BITS;

    parameter integer counter_bits = $ceil($clog2(PIXEL_ARRAY_WIDTH/OUTPUT_BUS_WIDTH));
    parameter integer counter_cycles = (PIXEL_ARRAY_WIDTH/OUTPUT_BUS_WIDTH) - 1;

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

    logic should_shift;
    logic set_register;
    wire [(OUTPUT_BUS_WIDTH*PIXEL_BITS)-1:0] local_data_out;

    RegisterShifter #(
        .bits(PIXEL_BITS*OUTPUT_BUS_WIDTH), 
        .length(PIXEL_ARRAY_WIDTH/OUTPUT_BUS_WIDTH)
    ) DataBuffer(
        .clk(CLK),
        .set(set_register & CLK),
        .set_select(SET_BUFFER & ~should_shift),
        .reset(RESET),
        .shift(CLK & should_shift),
        .data_in(DATA_IN),
        .data_out(local_data_out)
    );

    logic new_input;

    always_comb begin
        if (SET_BUFFER & ~sending_data) begin
            new_input = 1;
        end
        else begin
            new_input = 0;
        end
    end


    // SET_BUFFER is async because the flag originates from a circuit with a different clock, SENSOR_STATE
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

    assign OUTPUT_CLK = sending_data ? ~CLK : 0;

    Tristate Tristate [(OUTPUT_BUS_WIDTH*PIXEL_BITS)-1:0] (
        .A(local_data_out),
        .EN(sending_data),
        .Y(DATA_OUT)
    );


endmodule