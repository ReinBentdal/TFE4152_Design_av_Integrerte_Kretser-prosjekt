`ifndef _SELECTOR
`define _SELECTOR

`default_nettype none

module Selector(
    input clk,
    input inputEnable,
    input outputEnable,
    input reset,
    output [length-1:0] out
);

    parameter integer length = 4;

    logic [length-1:0] local_out;

    assign out = outputEnable ? local_out : 'Z;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            local_out <= 1;
        end
        else if (inputEnable) begin
            local_out <= local_out << 1;
        end
    end
endmodule

`endif