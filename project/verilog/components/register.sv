`ifndef _Register
`define _Register

`default_nettype none

module Register(set, reset, data_in, data_out);

    input set;
    input reset;
    input [bits-1:0] data_in;
    output logic [bits-1:0] data_out;

    parameter integer bits = 4;

    always_ff @( posedge set or posedge reset ) begin
        if (reset) begin
            data_out <= 0;
        end
        else begin
            data_out <= data_in;
        end
    end

endmodule

module RegisterShifter(clk, set, reset, shift, data_in, data_out);

    input clk;
    input set;
    input reset;
    input shift;
    input [bits*length-1:0] data_in;
    output [bits-1:0] data_out;

    parameter integer length = 4;
    parameter integer bits = 4;

    logic [length-1:0][bits-1:0] local_data_out;

    assign data_out = local_data_out[0];

    logic set_pulse;

    always_ff @( posedge set or posedge set_pulse or posedge reset) begin
        if (reset) begin
            set_pulse <= 0;
        end
        else if (set_pulse) begin
            set_pulse <= 0;
        end
        else begin
            set_pulse <= 1;
        end
    end

    genvar i;
    generate
        for (i = 0; i < length; i++) begin
            Register #(.bits(bits)) Register(
                .set(set_pulse | shift), // probably should not do set & clk because they originates from circuits with different clk and can result in very small pulse
                .reset(reset),
                .data_in(set 
                    ? data_in[i*bits +: bits] 
                    : i == length-1 
                        ? {bits{1'bX}} 
                        : local_data_out[i+1]
                ),
                .data_out(local_data_out[i])
            ); 
        end 
    endgenerate

endmodule

`endif