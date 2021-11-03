`include "../../pixel_sensor_config.sv"
`include "../../components/counter.sv"
`include "../../components/selector.sv"
`include "../../components/tristate.sv"

// reset should be triggered before use
module SENSOR_STATE(CLK, RESET, PIXEL_ERASE, PIXEL_EXPOSE, SENSOR_ROW_SELECT, NEW_ROW, PIXEL_ANALOG_RAMP, PIXEL_CONVERT_COUNTER, FRAME_FINISHED);

    import PixelSensorConfig::PIXEL_ARRAY_HEIGHT;
    import PixelSensorConfig::PIXEL_ARRAY_WIDTH;
    import PixelSensorConfig::PIXEL_BITS;

    input CLK;
    input RESET;
    output PIXEL_ERASE;
    output PIXEL_EXPOSE;
    output [PIXEL_ARRAY_HEIGHT-1:0] SENSOR_ROW_SELECT;
    output logic NEW_ROW;
    output PIXEL_ANALOG_RAMP;
    output [PIXEL_BITS-1:0] PIXEL_CONVERT_COUNTER;
    output FRAME_FINISHED;

    parameter erase_time = 5;
    parameter expose_time = 255;
    parameter convert_time = 255;
    parameter row_read_time = 5;
    parameter read_time = row_read_time*PIXEL_ARRAY_HEIGHT;

    parameter counter_bits = 10;

    parameter states = 4; // does not count idle state
    parameter idle_state = 0;
    parameter erase_state = 1;
    parameter expose_state = 1 << 1;
    parameter convert_state = 1 << 2;
    parameter read_state = 1 << 3;

    // reset for the entire module
    logic internal_reset;
    assign FRAME_FINISHED = internal_reset;
    wire master_reset;
    assign master_reset = RESET | internal_reset;



    //------------------------------------------------------------
    // Internal counter
    //------------------------------------------------------------
    logic [counter_bits-1:0] counter;
    
    logic counter_reset;
    wire master_counter_reset;
    assign master_counter_reset = master_reset || counter_reset;

    Counter #(.bits(counter_bits)) Counter(
        .clk(CLK),
        .reset(master_counter_reset),
        .enable(1'b1),
        .out(counter)
    );



    //------------------------------------------------------------
    // Digital RAMP
    //------------------------------------------------------------
    logic [PIXEL_BITS-1:0] dRamp;

    logic dRamp_enable;
    assign dRamp_enable = state[2];

    Counter #(.bits(8)) DRamp(
        .clk(CLK),
        .reset(master_reset),
        .enable(dRamp_enable),
        .out(PIXEL_CONVERT_COUNTER)
    );


    //------------------------------------------------------------
    // Row selector counter
    //------------------------------------------------------------
    logic rowSelect_counter_reset;
    logic rowSelect_counter_enable;
    logic [2:0] rowSelect_count;

    assign rowSelect_counter_enable = state[3];
    assign rowSelect_counter_reset = rowSelect_inc | (stateSelector_shift & state[3]);
    
    Counter #(.bits(3)) RowSelectorCounter(
        .clk(CLK),
        .reset(rowSelect_counter_reset || master_reset),
        .enable(rowSelect_counter_enable),
        .out(rowSelect_count)
    );

    //------------------------------------------------------------
    // Row selector shifter
    //------------------------------------------------------------
    logic rowSelect_inc;
    wire rowSelect_enable;
    assign rowSelect_enable = idle ? 0 : state[3];

    wire master_rowSelect_reset;
    assign master_rowSelect_reset = master_reset;

    Selector #(
        .length(PIXEL_ARRAY_HEIGHT)
    ) RowSelector(
        .clk(rowSelect_inc),
        .inputEnable(rowSelect_enable),
        .outputEnable(rowSelect_enable),
        .reset(master_rowSelect_reset),
        .out(SENSOR_ROW_SELECT)
    );


    //------------------------------------------------------------
    // Current STATE shifter
    //------------------------------------------------------------
    logic stateSelector_shift;
    logic [states-1:0] state;

    Selector #(
        .length(states)
    ) StateSelector(
        .clk(stateSelector_shift),
        .reset(master_reset),
        .inputEnable(1'b1),
        .outputEnable(1'b1),
        .out(state)
    );


    //------------------------------------------------------------
    // State machine
    //------------------------------------------------------------
    wire idle;
    assign idle = master_counter_reset;

    always_ff @(posedge CLK or posedge RESET) begin

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

                // continue to next stage if current stage is finished
                if (
                    (state == erase_state && counter == erase_time) || 
                    (state == expose_state && counter == expose_time) ||
                    (state == convert_state && counter == convert_time)
                ) begin             
                    counter_reset <= 1;
                end

                // cycle is finished and resets entire module
                else if (state == read_state && counter + 1 == read_time) begin
                    counter_reset <= 1;
                    internal_reset <= 1;
                end
                else if (state == read_state && rowSelect_count == (row_read_time - 2)) begin
                    rowSelect_inc <= 1;
                end
                else
                    rowSelect_inc <= 0;
            end
        end
    end

    //------------------------------------------------------------
    // output assign
    //------------------------------------------------------------
    assign PIXEL_ERASE = idle ? 0 : state[0];
    assign PIXEL_EXPOSE = idle ? 0 : state[1];
    assign PIXEL_ANALOG_RAMP = state == convert_state ? CLK : 0;


endmodule