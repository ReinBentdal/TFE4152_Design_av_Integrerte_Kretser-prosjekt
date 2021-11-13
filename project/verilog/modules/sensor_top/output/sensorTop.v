`default_nettype none
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
	parameter signed [7:0] bits = 4;
	output reg [bits - 1:0] out;
	always @(posedge clk or posedge reset)
		if (reset)
			out <= 0;
		else if (enable)
			out <= out + 1;
endmodule
`default_nettype none
module Graycounter (
	out,
	clk,
	reset
);
	parameter WIDTH = 8;
	output wire [WIDTH - 1:0] out;
	input clk;
	input reset;
	reg [WIDTH - 1:0] q;
	assign out = {q[WIDTH - 1], q[WIDTH - 1:1] ^ q[WIDTH - 2:0]};
	always @(posedge clk or posedge reset)
		if (reset)
			q <= 0;
		else
			q <= q + 1;
endmodule
module Graycounter_decode (
	in,
	out
);
	parameter WIDTH = 8;
	input [WIDTH - 1:0] in;
	output wire [WIDTH - 1:0] out;
	genvar i;
	generate
		for (i = 0; i < WIDTH; i = i + 1) begin : genblk1
			assign out[i] = ^in[WIDTH - 1:i];
		end
	endgenerate
endmodule
`default_nettype none
module Selector (
	clk,
	inputEnable,
	outputEnable,
	reset,
	out
);
	input clk;
	input inputEnable;
	input outputEnable;
	input reset;
	parameter integer length = 4;
	output wire [length - 1:0] out;
	reg [length - 1:0] local_out;
	assign out = (outputEnable ? local_out : {length {1'sbz}});
	always @(posedge clk or posedge reset)
		if (reset)
			local_out <= 1;
		else if (inputEnable)
			local_out <= local_out << 1;
endmodule
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
module SENSOR_STATE (
	CLK,
	RESET,
	PIXEL_ERASE,
	PIXEL_EXPOSE,
	SENSOR_ROW_SELECT,
	NEW_ROW,
	PIXEL_ANALOG_RAMP,
	PIXEL_DIGITAL_RAMP,
	FRAME_FINISHED
);
	input CLK;
	input RESET;
	output wire PIXEL_ERASE;
	output wire PIXEL_EXPOSE;
	localparam integer PIXEL_ARRAY_HEIGHT = 24;
	output wire [PIXEL_ARRAY_HEIGHT - 1:0] SENSOR_ROW_SELECT;
	output reg NEW_ROW;
	output wire PIXEL_ANALOG_RAMP;
	localparam PIXEL_BITS = 8;
	output wire [7:0] PIXEL_DIGITAL_RAMP;
	output wire FRAME_FINISHED;
	localparam erase_time = 5;
	localparam expose_time = 255;
	localparam convert_time = 255;
	localparam row_read_time = 5;
	localparam read_time = row_read_time * PIXEL_ARRAY_HEIGHT;
	localparam counter_bits = 10;
	localparam states = 4;
	localparam idle_state = 0;
	localparam erase_state = 1;
	localparam expose_state = 2;
	localparam convert_state = 4;
	localparam read_state = 8;
	reg internal_reset;
	assign FRAME_FINISHED = internal_reset;
	wire master_reset;
	assign master_reset = RESET | internal_reset;
	wire [9:0] counter;
	reg counter_reset;
	wire master_counter_reset;
	assign master_counter_reset = master_reset || counter_reset;
	Counter #(.bits(counter_bits)) Counter(
		.clk(CLK),
		.reset(master_counter_reset),
		.enable(1'b1),
		.out(counter)
	);
	wire [7:0] dRamp;
	wire dRamp_enable;
	wire [3:0] state;
	assign dRamp_enable = state[2];
	Graycounter #(.WIDTH(8)) DRamp(
		.clk(CLK & dRamp_enable),
		.reset(master_reset | counter_reset),
		.out(PIXEL_DIGITAL_RAMP)
	);
	wire rowSelect_counter_reset;
	wire rowSelect_counter_enable;
	wire [2:0] rowSelect_count;
	assign rowSelect_counter_enable = state[3];
	reg rowSelect_inc;
	reg stateSelector_shift;
	assign rowSelect_counter_reset = rowSelect_inc | (stateSelector_shift & state[3]);
	Counter #(.bits(3)) RowSelectorCounter(
		.clk(CLK),
		.reset(rowSelect_counter_reset || master_reset),
		.enable(rowSelect_counter_enable),
		.out(rowSelect_count)
	);
	wire rowSelect_enable;
	wire idle;
	assign rowSelect_enable = (idle ? 0 : state[3]);
	wire master_rowSelect_reset;
	assign master_rowSelect_reset = master_reset;
	wire [PIXEL_ARRAY_HEIGHT - 1:0] local_row_select;
	assign SENSOR_ROW_SELECT = (rowSelect_enable ? local_row_select : 0);
	Selector #(.length(PIXEL_ARRAY_HEIGHT)) RowSelector(
		.clk(rowSelect_inc),
		.inputEnable(rowSelect_enable),
		.outputEnable(rowSelect_enable),
		.reset(master_rowSelect_reset),
		.out(local_row_select)
	);
	Selector #(.length(states)) StateSelector(
		.clk(stateSelector_shift),
		.reset(master_reset),
		.inputEnable(1'b1),
		.outputEnable(1'b1),
		.out(state)
	);
	assign idle = master_counter_reset;
	always @(posedge CLK or posedge RESET)
		if (RESET) begin
			rowSelect_inc <= 0;
			stateSelector_shift <= 0;
			NEW_ROW <= 0;
			internal_reset <= 0;
			counter_reset <= 0;
		end
		else begin
			NEW_ROW <= rowSelect_inc | (stateSelector_shift & state[3]);
			if (idle) begin
				stateSelector_shift <= 1;
				counter_reset <= 0;
				internal_reset <= 0;
			end
			else begin
				stateSelector_shift <= 0;
				if ((((state == erase_state) && (counter == erase_time)) || ((state == expose_state) && (counter == expose_time))) || ((state == convert_state) && (counter == convert_time)))
					counter_reset <= 1;
				else if ((state == read_state) && ((counter + 1) == read_time)) begin
					counter_reset <= 1;
					internal_reset <= 1;
				end
				else if ((state == read_state) && (rowSelect_count == 3))
					rowSelect_inc <= 1;
				else
					rowSelect_inc <= 0;
			end
		end
	assign PIXEL_ERASE = (idle ? 0 : state[0]);
	assign PIXEL_EXPOSE = (idle ? 0 : state[1]);
	assign PIXEL_ANALOG_RAMP = ((state == convert_state) & ~idle ? CLK : 0);
endmodule
`default_nettype none
`default_nettype none
`default_nettype none
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
	localparam PIXEL_BITS = 8;
	localparam [4607:0] SCENE_24 = 4608'b110000001011110111000100110010001100100011000001110000001100000110111110101101011011001010101010100110111000110101111010011000110110101001111010100011011010111010111111101111001010000010111111111011111110100011101001111010011110111111110001111011101110011011011001101111111011110010110110101001101000101001110101011011101000111110101101101110011100110011010001101001001100000111001111110001001011100110110100101010001010000110100001100101111000110010011011100110110111001101101110010111110101001101000110010011000110001001111100010110100100101000101111001001010001110000010111001101100011011100111110001101010011000000110010001101110011101100111110011101010110011001000001010010000101001101010010010011110101011101001110010110110011011100110000001000000001101000011010010001100101010101010111010001110011101000111010010000010100011001011001011010000110010001010010011001100110110001011001010110000100101001000101010110000100001100110000001000110001110100011100010111110101101001010110010001000011101100111010010001010110101110000111100010011000100110010110101010011001111101110001010101110100000101010111010110100011101000101110001010010010010100100010010111010100111100111100001101010011111001000001011101111001010110100010101001001010100110110001110001001010101001101010011011000111000001100101001010100011001100110000001011010010110000101000010100010011101100110100001101100011111001101110101000111010011110101111101101111011101110111110101100111000001001100011011001010110010001001000010010010100110100110101001100100011010000110010001111110011010100110101001101100011110010100000101010111011010011000001110010001100111110110010011011100100001001001001010101000101100001110100010101110011011000110110001100110011010100110100010000010011101100111011001111000100011010110001101110011100000111001101110101111011001001010100010011110101101101100101011010011000010110000110001111100011100100111000001100110011010000110111010010010100010001000000001111110100101110110000110010001011101111010001110011011000100001011100010111100110100001110101100011011010001001001110010001000011111000111011001101110011010000110111010100000100100101000101010010010101101110001001110011101101010111010000100111010110100101100111011011011000000010001111101001010110110001001011010001100100000100111100001101100011000100110100010110100101001101001110010011010110011001101100101110001100011010001011011100100110111001101111011100000111110010011000100001110100100101001011010001110100000100111100001101000011001000110101010110010101011101010011010100010110100101011000100000101000100010000010100000000111100001110000011100111000011010001101010011110100101101001101010010010100001100111100001101000011001000110101010101010101010001010100010101100101100001011110011101001001000110010010100010100111111101111101100011001001010001011010010100000101000101010001010011100100011001000000001110010011011100111010010101010101001101010110010110100101010101000110010111011000110110001101100011011000110110010011100100110101111101010011010101000101010001010101010101000100111001001100010001010100001001000011010100110101011010001001100011100111010101000010010111001000111101111111100001111001001010010001010111100101101001011010010110100101011001010111010101110101001101010010010011000100011001000111010101110101101001100100110000101001010101000100011101101001000110000010100100101001110101100011011000010101111101011100010111010101101001011000010101110101001001010000010010110100011001000110010110110101110001100000011001000111001101101111100001001001101110110001101000000110100101100001011000100110000101011100010111100101101101011001010100100100110101001000010000110011111000111110010111000101111001011111011000010110010001101101100000001001101110000110011001000110001101011110010111110101111001010111010110000101100001010011010010110100001000111110001110010011010100110110010100110101011101011000010101010101011101011011010111010110010001101000011000110101111001010101010101010101000101001001010011000100110001001001010000010011010100110000001011110010110000101101010010010100101101001011010010110100110101010011010101100101110101100001011000000101101001001111010011010100010100111101010000110100001000111111001101110010101100100111001001110010010100100111001111100011111000111110010000000100001101001010010011010101011101011100010111100101100001001001010001010011110000110010001101100011100000110101001011110010011000100100001001000010001100100101001111010011110000111100001111000011111101000111010011010101011101011101010111110101101001001100010010000011111000110011001101100011011100110101001100010010100100100111001001110010010100101000;
	parameter [7:0] expose_value = 255 - SCENE_24[8 * (width_index + (height_index * 24))+:8];
	wire [7:0] EXPOSE_VALUE;
	assign EXPOSE_VALUE = expose_value;
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
	ANALOG_RAMP,
	ERASE,
	EXPOSE,
	READ,
	DIGITAL_RAMP,
	DATA
);
	input ANALOG_RAMP;
	input ERASE;
	input EXPOSE;
	input READ;
	input [PIXEL_BITS - 1:0] DIGITAL_RAMP;
	output wire [PIXEL_BITS - 1:0] DATA;
	parameter integer width_index = 0;
	parameter integer height_index = 0;
	localparam PIXEL_BITS = 8;
	reg [7:0] local_data;
	Tristate Tristate[7:0](
		.A(local_data),
		.EN(READ),
		.Y(DATA)
	);
	wire cmp;
	always @(*)
		if (!cmp)
			local_data = DIGITAL_RAMP;
	PIXEL_SENSOR_ANALOG #(
		.width_index(width_index),
		.height_index(height_index)
	) PixelSensorAnalog(
		.EXPOSE(EXPOSE),
		.RAMP(ANALOG_RAMP),
		.ERASE(ERASE),
		.CMP(cmp)
	);
endmodule
`default_nettype none
module PIXEL_ROW (
	ANALOG_RAMP,
	ERASE,
	EXPOSE,
	READ,
	DIGITAL_RAMP,
	DATA_OUT
);
	input ANALOG_RAMP;
	input ERASE;
	input EXPOSE;
	input READ;
	input [7:0] DIGITAL_RAMP;
	localparam integer PIXEL_ARRAY_WIDTH = 24;
	localparam PIXEL_BITS = 8;
	output wire [(PIXEL_ARRAY_WIDTH * 8) - 1:0] DATA_OUT;
	parameter row_index = 0;
	genvar i;
	generate
		for (i = 0; i < PIXEL_ARRAY_WIDTH; i = i + 1) begin : genblk1
			PIXEL_SENSOR #(
				.width_index(i),
				.height_index(row_index)
			) ps(
				.ANALOG_RAMP(ANALOG_RAMP),
				.ERASE(ERASE),
				.EXPOSE(EXPOSE),
				.READ(READ),
				.DATA(DATA_OUT[i * 8+:8]),
				.DIGITAL_RAMP(DIGITAL_RAMP)
			);
		end
	endgenerate
endmodule
module PIXEL_ARRAY (
	ANALOG_RAMP,
	ERASE,
	EXPOSE,
	READ,
	DIGITAL_RAMP,
	DATA_OUT
);
	input ANALOG_RAMP;
	input ERASE;
	input EXPOSE;
	localparam integer PIXEL_ARRAY_HEIGHT = 24;
	input [PIXEL_ARRAY_HEIGHT - 1:0] READ;
	input [7:0] DIGITAL_RAMP;
	localparam integer PIXEL_ARRAY_WIDTH = 24;
	localparam PIXEL_BITS = 8;
	output wire [(PIXEL_ARRAY_WIDTH * 8) - 1:0] DATA_OUT;
	genvar i;
	generate
		for (i = 0; i < PIXEL_ARRAY_HEIGHT; i = i + 1) begin : genblk1
			PIXEL_ROW #(.row_index(i)) pr(
				.ANALOG_RAMP(ANALOG_RAMP),
				.ERASE(ERASE),
				.EXPOSE(EXPOSE),
				.READ(READ[i]),
				.DIGITAL_RAMP(DIGITAL_RAMP),
				.DATA_OUT(DATA_OUT)
			);
		end
	endgenerate
endmodule
`default_nettype none
`default_nettype none
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
			data_out <= 'bx;
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
module OUTPUT_BUFFER (
	SET_BUFFER,
	RESET,
	CLK,
	DATA_IN,
	OUTPUT_CLK,
	DATA_OUT
);
	input SET_BUFFER;
	input RESET;
	input CLK;
	input [(PIXEL_ARRAY_WIDTH * PIXEL_BITS) - 1:0] DATA_IN;
	output wire OUTPUT_CLK;
	output wire [(OUTPUT_BUS_WIDTH * PIXEL_BITS) - 1:0] DATA_OUT;
	localparam OUTPUT_BUS_WIDTH = 8;
	localparam integer PIXEL_ARRAY_WIDTH = 24;
	parameter integer counter_bits = $ceil(2);
	parameter integer counter_cycles = (PIXEL_ARRAY_WIDTH / OUTPUT_BUS_WIDTH) - 1;
	localparam PIXEL_BITS = 8;
	wire [(PIXEL_ARRAY_WIDTH * 8) - 1:0] data_in_decode;
	Graycounter_decode #(.WIDTH(PIXEL_BITS)) decoder[PIXEL_ARRAY_WIDTH - 1:0](
		.in(DATA_IN),
		.out(data_in_decode)
	);
	reg sending_data;
	reg counter_reset;
	wire [counter_bits - 1:0] counter_out;
	Counter #(.bits(counter_bits)) Counter(
		.clk(CLK),
		.reset(counter_reset | RESET),
		.enable(sending_data),
		.out(counter_out)
	);
	reg should_shift;
	wire shift;
	assign shift = should_shift & CLK;
	reg set_register;
	wire [63:0] local_data_out;
	wire set_select;
	reg new_input;
	assign set_select = new_input | (set_register & CLK);
	RegisterShifter #(
		.bits(64),
		.length(PIXEL_ARRAY_WIDTH / OUTPUT_BUS_WIDTH)
	) DataBuffer(
		.set(set_register & CLK),
		.set_select(set_select),
		.reset(RESET),
		.shift(CLK & should_shift),
		.data_in(data_in_decode),
		.data_out(local_data_out)
	);
	always @(*)
		if (SET_BUFFER & ~sending_data)
			new_input = 1;
		else
			new_input = 0;
	always @(posedge CLK or posedge RESET)
		if (RESET) begin
			sending_data <= 0;
			counter_reset <= 0;
			should_shift <= 0;
			set_register <= 0;
		end
		else begin
			if (sending_data)
				should_shift <= 1;
			if (counter_reset)
				counter_reset <= 0;
			if (new_input) begin
				sending_data <= 1;
				set_register <= 1;
			end
			if (set_register)
				set_register <= 0;
			else if (counter_out == counter_cycles) begin
				counter_reset <= 1;
				sending_data <= 0;
				should_shift <= 0;
			end
		end
	assign OUTPUT_CLK = (sending_data ? ~CLK : 0);
	Tristate Tristate[63:0](
		.A(local_data_out),
		.EN(sending_data),
		.Y(DATA_OUT)
	);
endmodule
module SENSOR_TOP (
	CLK,
	RESET,
	BUFFER_CLK,
	OUTPUT_CLK,
	DATA_OUT,
	FRAME_FINISHED
);
	input CLK;
	input RESET;
	input BUFFER_CLK;
	output wire OUTPUT_CLK;
	localparam OUTPUT_BUS_WIDTH = 8;
	localparam PIXEL_BITS = 8;
	output wire [63:0] DATA_OUT;
	output wire FRAME_FINISHED;
	wire sensor_erase;
	wire sensor_expose;
	localparam integer PIXEL_ARRAY_HEIGHT = 24;
	wire [PIXEL_ARRAY_HEIGHT - 1:0] sensor_row_select;
	wire sensor_new_row;
	wire sensor_analog_ramp;
	wire [7:0] pixel_digital_ramp;
	localparam integer PIXEL_ARRAY_WIDTH = 24;
	wire [(PIXEL_ARRAY_WIDTH * 8) - 1:0] sensor_data_out;
	PIXEL_ARRAY PixelArray(
		.ERASE(sensor_erase),
		.EXPOSE(sensor_expose),
		.READ(sensor_row_select),
		.DIGITAL_RAMP(pixel_digital_ramp),
		.ANALOG_RAMP(sensor_analog_ramp),
		.DATA_OUT(sensor_data_out)
	);
	SENSOR_STATE SensorState(
		.CLK(CLK),
		.RESET(RESET),
		.PIXEL_ERASE(sensor_erase),
		.PIXEL_EXPOSE(sensor_expose),
		.SENSOR_ROW_SELECT(sensor_row_select),
		.NEW_ROW(sensor_new_row),
		.PIXEL_ANALOG_RAMP(sensor_analog_ramp),
		.PIXEL_DIGITAL_RAMP(pixel_digital_ramp),
		.FRAME_FINISHED(FRAME_FINISHED)
	);
	OUTPUT_BUFFER OutputBuffer(
		.SET_BUFFER(sensor_new_row),
		.RESET(RESET),
		.CLK(BUFFER_CLK),
		.DATA_IN(sensor_data_out),
		.OUTPUT_CLK(OUTPUT_CLK),
		.DATA_OUT(DATA_OUT)
	);
endmodule