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
            data_out <= 'bx;
        end
        else begin
            data_out <= data_in;
        end
    end

endmodule

/*
Distinguishing between set and set_select because set_select needs to hold for longer
*/
module RegisterShifter(set, set_select, reset, shift, data_in, data_out);

    input set;
    input set_select;
    input reset;
    input shift;
    input [bits*length-1:0] data_in;
    output [bits-1:0] data_out;

    parameter integer length = 4;
    parameter integer bits = 4;

    logic [length-1:0][bits-1:0] local_data_out;

    assign data_out = local_data_out[0];


    genvar i;
    generate
        for (i = 0; i < length; i++) begin
            Register #(.bits(bits)) Register(
                .set(set | shift),
                .reset(reset),
                .data_in(set_select
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