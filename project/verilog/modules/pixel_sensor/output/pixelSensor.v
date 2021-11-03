`default_nettype none
module Tristate (
	A,
	EN,
	Y
);
	input A;
	input EN;
	output wire Y;
	assign Y = (EN ? A : 1'bz);
endmodule
module TristateBus (
	A,
	EN,
	Y
);
	parameter integer width = 2;
	input wire [width - 1:0] A;
	input EN;
	output wire [width - 1:0] Y;
	Tristate Tristate[width - 1:0](
		.A(A),
		.EN(EN),
		.Y(Y)
	);
endmodule
`default_nettype none
`default_nettype none
module Counter (
	clk,
	reset,
	enable,
	out
);
	input clk;
	input reset;
	input enable;
	parameter signed [7:0] bits = 2;
	output reg [bits - 1:0] out;
	always @(posedge clk or posedge reset)
		if (reset)
			out <= 0;
		else if (enable)
			out <= out + 1;
endmodule
module PIXEL_SENSOR_ANALOG (
	EXPOSE,
	RAMP,
	ERASE,
	CMP
);
	input EXPOSE;
	input RAMP;
	input ERASE;
	output reg CMP;
	parameter integer width_index = 0;
	parameter integer height_index = 0;
	parameter integer expose_value = ((width_index + 1) * (height_index + 1)) % 256;
	wire [7:0] expose_cmp;
	Counter #(.bits(8)) Counter(
		.clk(RAMP),
		.reset(ERASE),
		.enable(1'b1),
		.out(expose_cmp)
	);
	always @(posedge RAMP or posedge ERASE)
		if (ERASE)
			CMP <= 0;
		else if (expose_cmp == expose_value)
			CMP <= 1;
endmodule
module PIXEL_SENSOR (
	RAMP,
	ERASE,
	EXPOSE,
	READ,
	COUNTER,
	DATA
);
	input RAMP;
	input ERASE;
	input EXPOSE;
	input READ;
	input [PIXEL_BITS - 1:0] COUNTER;
	output wire [PIXEL_BITS - 1:0] DATA;
	parameter integer width_index = 0;
	parameter integer height_index = 0;
	localparam PIXEL_BITS = 8;
	reg [7:0] local_data;
	assign DATA = (READ ? local_data : 'bz);
	wire cmp;
	always @(*)
		if (!cmp)
			local_data = COUNTER;
	PIXEL_SENSOR_ANALOG #(
		.width_index(width_index),
		.height_index(height_index)
	) PixelSensorAnalog(
		.EXPOSE(EXPOSE),
		.RAMP(RAMP),
		.ERASE(ERASE),
		.CMP(cmp)
	);
endmodule