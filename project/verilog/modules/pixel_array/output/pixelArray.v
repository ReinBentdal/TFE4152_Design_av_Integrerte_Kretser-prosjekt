`default_nettype none
`default_nettype none
module PIXEL_SENSOR (
	VBN1,
	RAMP,
	ERASE,
	EXPOSE,
	READ,
	COUNTER,
	DATA
);
	input wire VBN1;
	input wire RAMP;
	input wire ERASE;
	input wire EXPOSE;
	input wire READ;
	input [PIXEL_BITS - 1:0] COUNTER;
	output wire [PIXEL_BITS - 1:0] DATA;
	parameter integer width_index = 0;
	parameter integer height_index = 0;
	reg cmp;
	localparam PIXEL_BITS = 8;
	reg [7:0] p_data;
	always @(posedge cmp) p_data <= COUNTER;
	assign DATA = (READ ? p_data : 8'bzzzzzzzz);
	always @(posedge VBN1) cmp <= VBN1;
endmodule
`default_nettype none
module PIXEL_ROW (
	VBN1,
	RAMP,
	ERASE,
	EXPOSE,
	READ,
	COUNTER,
	DATA_OUT
);
	input wire VBN1;
	input wire RAMP;
	input wire ERASE;
	input wire EXPOSE;
	input wire READ;
	input [7:0] COUNTER;
	output wire [(PIXEL_ARRAY_WIDTH * PIXEL_BITS) - 1:0] DATA_OUT;
	parameter row_index = 0;
	genvar i;
	localparam integer PIXEL_ARRAY_WIDTH = 3;
	localparam integer PIXEL_BITS = 8;
	generate
		for (i = 0; i < PIXEL_ARRAY_WIDTH; i = i + 1) begin : genblk1
			PIXEL_SENSOR #(
				.width_index(i),
				.height_index(row_index)
			) ps(
				.VBN1(VBN1),
				.RAMP(RAMP),
				.ERASE(ERASE),
				.EXPOSE(EXPOSE),
				.READ(READ),
				.DATA(DATA_OUT[i * PIXEL_BITS+:PIXEL_BITS]),
				.COUNTER(COUNTER)
			);
		end
	endgenerate
endmodule
module PIXEL_ARRAY (
	VBN1,
	RAMP,
	ERASE,
	EXPOSE,
	READ,
	COUNTER,
	DATA_OUT
);
	input wire VBN1;
	input wire RAMP;
	input wire ERASE;
	input wire EXPOSE;
	input [PIXEL_ARRAY_HEIGHT - 1:0] READ;
	input [7:0] COUNTER;
	output wire [(PIXEL_ARRAY_WIDTH * PIXEL_BITS) - 1:0] DATA_OUT;
	genvar i;
	localparam integer PIXEL_ARRAY_WIDTH = 3;
	localparam integer PIXEL_ARRAY_HEIGHT = 3;
	localparam integer PIXEL_BITS = 8;
	generate
		for (i = 0; i < PIXEL_ARRAY_HEIGHT; i = i + 1) begin : genblk1
			PIXEL_ROW #(.row_index(i)) pr(
				.VBN1(VBN1),
				.RAMP(RAMP),
				.ERASE(ERASE),
				.EXPOSE(EXPOSE),
				.READ(READ[i]),
				.COUNTER(COUNTER),
				.DATA_OUT(DATA_OUT)
			);
		end
	endgenerate
endmodule