`include "../../pixel_sensor_config.sv"
`include "../../components/counter.sv"
`include "../../components/shifter.sv"

// reset should be triggered before use
module SENSOR_STATE(
    input clk,
    input reset,
    output p_erase,
    output p_expose,
    output tri p_expose_clk,
    output [PIXEL_ARRAY_HEIGHT-1:0] p_row_select,
    output new_row,
    output p_aRamp,
    output [PIXEL_BITS-1:0] p_dRamp,
    output pixel_frame_finished
);

    import PixelSensorConfig::PIXEL_ARRAY_HEIGHT;
    import PixelSensorConfig::PIXEL_ARRAY_WIDTH;
    import PixelSensorConfig::PIXEL_BITS;

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
    assign pixel_frame_finished = internal_reset;
    wire master_reset;
    assign master_reset = reset | internal_reset;



    //------------------------------------------------------------
    // Internal counter
    //------------------------------------------------------------
    logic [counter_bits-1:0] counter;
    
    logic counter_reset;
    wire master_counter_reset;
    assign master_counter_reset = master_reset | counter_reset;

    Counter #(.bits(counter_bits)) Counter(
        .clk(clk),
        .reset(master_counter_reset),
        .enable(1'b1),
        .out(counter)
    );



    //------------------------------------------------------------
    // Digital RAMP
    //------------------------------------------------------------
    logic [PIXEL_BITS-1:0] dRamp;

    logic dRamp_reset;
    wire master_dRamp_reset;
    assign master_dRamp_reset = master_reset | dRamp_reset;

    wire dRamp_enable;
    assign dRamp_enable = state == convert_state;

    Counter #(.bits(8)) DRamp(
        .clk(clk),
        .reset(master_dRamp_reset),
        .enable(dRamp_enable),
        .out(p_dRamp)
    );



    //------------------------------------------------------------
    // Row selector shifter
    //------------------------------------------------------------
    logic rowSelect_inc;
    wire rowSelect_enable;
    assign rowSelect_enable = idle ? 0 : state[3];

    wire master_rowSelect_reset;
    assign master_rowSelect_reset = master_reset;

    CircularShifter #(
        .length(PIXEL_ARRAY_HEIGHT)
    ) RowSelector(
        .clk(rowSelect_inc),
        .inputEnable(rowSelect_enable),
        .outputEnable(rowSelect_enable),
        .reset(master_rowSelect_reset),
        .out(p_row_select)
    );

    assign new_row = rowSelect_inc | (stateSelector_shift & state[3]);


    //------------------------------------------------------------
    // Current STATE shifter
    //------------------------------------------------------------
    logic stateSelector_shift;
    logic [states-1:0] state;

    CircularShifter #(
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

    always_ff @(posedge clk) begin

        if (idle) begin
            stateSelector_shift <= 1;
            counter_reset <= 0;
            internal_reset <= 0;
        end
        else begin

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
            else begin
                stateSelector_shift <= 0;

                // handle which row is selected
                if (state == read_state && counter != 0 && (counter + 1) % row_read_time == 0)
                    rowSelect_inc <= 1;
                else
                    rowSelect_inc <= 0;
            end    
        end
    end

    //------------------------------------------------------------
    // output assign
    //------------------------------------------------------------
    assign p_erase = idle ? 0 : state[0];
    assign p_expose = idle ? 0 : state[1];
    assign p_aRamp = state == convert_state ? clk : 1'bX;
    assign p_expose_clk = state == expose_state ? clk : 1'bX;

    always_ff @(posedge reset ) begin
        rowSelect_inc <= 0;
    end

    // always_ff @(negedge internal_reset)
    //     $stop;

endmodule