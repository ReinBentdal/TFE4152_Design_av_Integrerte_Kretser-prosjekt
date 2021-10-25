`include "../../pixel_sensor_config.sv"
`include "../../components/counter.sv"

module OUTPUT_BUFFER(
    input set,
    input reset,
    input clk,
    input [PIXEL_ARRAY_WIDTH-1:0][PIXEL_BITS-1:0] data_inn,
    output logic output_clk,
    output [OUTPUT_BUS_WIDTH-1:0][PIXEL_BITS-1:0] data_out
);

    import PixelSensorConfig::PIXEL_ARRAY_WIDTH;
    import PixelSensorConfig::OUTPUT_BUS_WIDTH;
    import PixelSensorConfig::PIXEL_BITS;

    parameter integer counter_bits = $ceil($clog2(PIXEL_ARRAY_WIDTH));

    logic new_out_data;
    logic new_out_sending;
    logic counter_reset;
    wire [counter_bits-1:0] counter_out;

    Counter #(
        .bits(counter_bits)
    ) Counter(
        .clk(clk),
        .reset(counter_reset || reset),
        .enable(new_out_data),
        .out(counter_out)
    );

    logic [PIXEL_ARRAY_WIDTH-1:0][PIXEL_BITS-1:0] data_buffer;

    always_ff @(negedge set) begin
        if (!reset) begin
            data_buffer <= data_inn;
            new_out_data <= 1;
        end
    end

    always_ff @(posedge clk) begin
        if (counter_reset)
            counter_reset <= 0;

        if (counter_out == (PIXEL_ARRAY_WIDTH/OUTPUT_BUS_WIDTH)-1) begin
            new_out_data <= 0;
            counter_reset <= 1;
        end

        // delay sending new data to next clock cycle. This to prevent sending on a short clock cycle
        if (new_out_data)
            new_out_sending <= 1;
        else
            new_out_sending <= 0;

        if (counter_out != 0)
            data_buffer <= data_buffer >> OUTPUT_BUS_WIDTH*PIXEL_BITS;
    end

    always_ff @( posedge reset ) begin
        new_out_data <= 0;
        counter_reset <= 0;
    end

    always_ff @(posedge clk or negedge clk) output_clk <= new_out_data ? clk : 0;

    // assign output_clk = new_out_sending ? clk : 0;

    assign data_out = data_buffer[0:OUTPUT_BUS_WIDTH-1];

endmodule