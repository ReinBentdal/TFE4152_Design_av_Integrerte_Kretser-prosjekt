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
	parameter signed [7:0] bits = 2;
	output reg [bits - 1:0] out;
	always @(posedge clk or posedge reset)
		if (reset)
			out <= 0;
		else if (enable)
			out <= out + 1;
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
	PIXEL_CONVERT_COUNTER,
	FRAME_FINISHED
);
	input CLK;
	input RESET;
	output wire PIXEL_ERASE;
	output wire PIXEL_EXPOSE;
	localparam integer PIXEL_ARRAY_HEIGHT = 3;
	output wire [PIXEL_ARRAY_HEIGHT - 1:0] SENSOR_ROW_SELECT;
	output reg NEW_ROW;
	output wire PIXEL_ANALOG_RAMP;
	localparam PIXEL_BITS = 8;
	output wire [7:0] PIXEL_CONVERT_COUNTER;
	output wire FRAME_FINISHED;
	parameter erase_time = 5;
	parameter expose_time = 255;
	parameter convert_time = 255;
	parameter row_read_time = 5;
	parameter read_time = row_read_time * PIXEL_ARRAY_HEIGHT;
	parameter counter_bits = 10;
	parameter states = 4;
	parameter idle_state = 0;
	parameter erase_state = 1;
	parameter expose_state = 2;
	parameter convert_state = 4;
	parameter read_state = 8;
	reg internal_reset;
	assign FRAME_FINISHED = internal_reset;
	wire master_reset;
	assign master_reset = RESET | internal_reset;
	wire [counter_bits - 1:0] counter;
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
	wire [states - 1:0] state;
	assign dRamp_enable = state[2];
	Counter #(.bits(8)) DRamp(
		.clk(CLK),
		.reset(master_reset),
		.enable(dRamp_enable),
		.out(PIXEL_CONVERT_COUNTER)
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
	Selector #(.length(PIXEL_ARRAY_HEIGHT)) RowSelector(
		.clk(rowSelect_inc),
		.inputEnable(rowSelect_enable),
		.outputEnable(rowSelect_enable),
		.reset(master_rowSelect_reset),
		.out(SENSOR_ROW_SELECT)
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
				else if ((state == read_state) && (rowSelect_count == (row_read_time - 2)))
					rowSelect_inc <= 1;
				else
					rowSelect_inc <= 0;
			end
		end
	assign PIXEL_ERASE = (idle ? 0 : state[0]);
	assign PIXEL_EXPOSE = (idle ? 0 : state[1]);
	assign PIXEL_ANALOG_RAMP = (state == convert_state ? CLK : 0);
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
	Tristate Tristate[7:0](
		.A(local_data),
		.EN(READ),
		.Y(DATA)
	);
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
`default_nettype none
module PIXEL_ROW (
	RAMP,
	ERASE,
	EXPOSE,
	READ,
	COUNTER,
	DATA_OUT
);
	input RAMP;
	input ERASE;
	input EXPOSE;
	input READ;
	input [7:0] COUNTER;
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
				.RAMP(RAMP),
				.ERASE(ERASE),
				.EXPOSE(EXPOSE),
				.READ(READ),
				.DATA(DATA_OUT[i * 8+:8]),
				.COUNTER(COUNTER)
			);
		end
	endgenerate
endmodule
module PIXEL_ARRAY (
	RAMP,
	ERASE,
	EXPOSE,
	READ,
	COUNTER,
	DATA_OUT
);
	input RAMP;
	input ERASE;
	input EXPOSE;
	localparam integer PIXEL_ARRAY_HEIGHT = 3;
	input [PIXEL_ARRAY_HEIGHT - 1:0] READ;
	input [7:0] COUNTER;
	localparam integer PIXEL_ARRAY_WIDTH = 24;
	localparam PIXEL_BITS = 8;
	output wire [(PIXEL_ARRAY_WIDTH * 8) - 1:0] DATA_OUT;
	genvar i;
	generate
		for (i = 0; i < PIXEL_ARRAY_HEIGHT; i = i + 1) begin : genblk1
			PIXEL_ROW #(.row_index(i)) pr(
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
			data_out <= 0;
		else
			data_out <= data_in;
endmodule
module RegisterShifter (
	clk,
	set,
	reset,
	shift,
	data_in,
	data_out
);
	input clk;
	input set;
	input reset;
	input shift;
	parameter integer bits = 4;
	parameter integer length = 4;
	input [(bits * length) - 1:0] data_in;
	output wire [bits - 1:0] data_out;
	wire [(length * bits) - 1:0] local_data_out;
	assign data_out = local_data_out[0+:bits];
	reg set_pulse;
	always @(posedge set or posedge set_pulse or posedge reset)
		if (reset)
			set_pulse <= 0;
		else if (set_pulse)
			set_pulse <= 0;
		else
			set_pulse <= 1;
	genvar i;
	generate
		for (i = 0; i < length; i = i + 1) begin : genblk1
			Register #(.bits(bits)) Register(
				.set(set_pulse | shift),
				.reset(reset),
				.data_in((set ? data_in[i * bits+:bits] : (i == (length - 1) ? {bits {1'bx}} : local_data_out[(i + 1) * bits+:bits]))),
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
	localparam PIXEL_BITS = 8;
	wire [63:0] local_data_out;
	reg new_input;
	RegisterShifter #(
		.bits(64),
		.length(PIXEL_ARRAY_WIDTH / OUTPUT_BUS_WIDTH)
	) DataBuffer(
		.clk(CLK),
		.set(new_input),
		.reset(RESET),
		.shift(CLK & should_shift),
		.data_in(DATA_IN),
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
		end
		else begin
			if (sending_data)
				should_shift <= 1;
			if (counter_reset)
				counter_reset <= 0;
			if (new_input)
				sending_data <= 1;
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
	localparam integer PIXEL_ARRAY_HEIGHT = 3;
	wire [PIXEL_ARRAY_HEIGHT - 1:0] sensor_row_select;
	wire sensor_new_row;
	wire sensor_analog_ramp;
	wire [7:0] pixel_convert_counter;
	localparam integer PIXEL_ARRAY_WIDTH = 24;
	wire [(PIXEL_ARRAY_WIDTH * 8) - 1:0] sensor_data_out;
	PIXEL_ARRAY PixelArray(
		.ERASE(sensor_erase),
		.EXPOSE(sensor_expose),
		.READ(sensor_row_select),
		.COUNTER(pixel_convert_counter),
		.RAMP(sensor_analog_ramp),
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
		.PIXEL_CONVERT_COUNTER(pixel_convert_counter),
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