`ifndef _SHIFTER
`define _SHIFTER

module CircularShifter(
    input clk,
    input inputEnable,
    input outputEnable,
    input reset,
    output [length-1:0] out
);

    parameter byte length = 4;

    logic [length-1:0] local_out = 1;

    assign out = outputEnable ? local_out : 'X;

    always_ff @(posedge clk, posedge reset) begin
        if (reset)
            local_out = 1;
        else if (inputEnable) begin
            local_out[0] <= local_out[length-1];
            local_out = local_out << 1;
        end
    end

endmodule

module Shifter(
    input clk,
    input enable,
    input reset,
    output [length-1:0] out
);

    parameter integer length = 4;

    logic [length-1:0] local_out = 1;

    assign out = enable ? local_out : 'X;

    always_ff @(posedge clk) begin
        if (reset) begin
            local_out = 1;
        end
        local_out = local_out << 1;
    end
endmodule

`endif