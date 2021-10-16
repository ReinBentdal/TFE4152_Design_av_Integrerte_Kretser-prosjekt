`ifndef _COUNTER
`define _COUNTER

module Counter(
    input clk,
    input reset,
    input enable,
    output logic [bits-1:0] out
);

    parameter byte bits = 2;

    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            out = 0;
        end
        else if (enable) begin
            out = out + 1;
        end
    end
endmodule

`endif