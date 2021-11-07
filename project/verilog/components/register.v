`default_nettype none
module Register (
	set,
	reset,
	data_in,
	data_out
);
	input set;
	input reset;
	parameter integer bits = 4;
	input [bits - 1:0] data_in;
	output reg [bits - 1:0] data_out;
	always @(posedge set or posedge reset)
		if (reset)
			data_out <= 0;
		else
			data_out <= data_in;
endmodule
module RegisterShifter (
	set,
	set_select,
	reset,
	shift,
	data_in,
	data_out
);
	input set;
	input set_select;
	input reset;
	input shift;
	parameter integer bits = 4;
	parameter integer length = 4;
	input [(bits * length) - 1:0] data_in;
	output wire [bits - 1:0] data_out;
	wire [(length * bits) - 1:0] local_data_out;
	assign data_out = local_data_out[0+:bits];
	genvar i;
	generate
		for (i = 0; i < length; i = i + 1) begin : genblk1
			Register #(.bits(bits)) Register(
				.set(set | shift),
				.reset(reset),
				.data_in((set_select ? data_in[i * bits+:bits] : (i == (length - 1) ? {bits {1'bx}} : local_data_out[(i + 1) * bits+:bits]))),
				.data_out(local_data_out[i * bits+:bits])
			);
		end
	endgenerate
endmodule