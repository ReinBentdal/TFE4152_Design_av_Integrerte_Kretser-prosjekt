`ifndef _TRISTATE
`define _TRISTATE

module Tristate(
    input A,
    input EN,
    output Y
);
    assign Y = EN ? A : 1'bz;
endmodule

module TristateBus(
    input logic[width-1:0] A,
    input EN,
    output logic[width-1:0] Y
);
    parameter integer width = 2;
    Tristate Tristate[width-1:0](
        .A(A),
        .EN(EN),
        .Y(Y)
    );

endmodule

`endif