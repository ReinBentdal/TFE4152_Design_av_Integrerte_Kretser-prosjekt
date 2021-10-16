

module shifter(
    input clk,
    input enable,
    input reset,
    output [length-1:0] out
);

    parameter integer length = 4;

    logic [length-1:0] local_out = 1;

    assign out = enable ? out : 1'bZ;

    always @(posedge clk) begin
        local_out = local_out << 1;
    end

    always @(posedge reset) begin
        local_out = 1;
    end

endmodule