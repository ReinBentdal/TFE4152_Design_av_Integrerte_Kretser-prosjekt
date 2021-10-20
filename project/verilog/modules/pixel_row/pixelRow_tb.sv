`include "../../pixel_sensor_config.sv"
`include "pixelRow.sv"

`timescale 1 ns / 1 ps

module pixelRow_tb;

   import PixelSensorConfig::PIXEL_ARRAY_WIDTH;

    logic clk = 0;
    logic reset = 0;

    parameter integer clk_period = 500;
    parameter integer sim_end = clk_period*2400;

    always #clk_period clk=~clk;

    logic analog_bias;
    logic analog_ramp;
    logic analog_reset;

    logic erase;
    logic expose;
    logic read;

    logic [7:0] pixel_counter;

    logic [PIXEL_ARRAY_WIDTH-1:0][7:0] rowData;

    PIXEL_ROW pixel_row(
        .VBN1(analog_bias),
        .RAMP(analog_ramp),
        .ERASE(erase),
        .EXPOSE(expose),
        .READ(read),
        .DATA_OUT(rowData),
        .COUNTER(pixel_counter)
    );

    //------------------------------------------------------------
   // State Machine
   //------------------------------------------------------------
   parameter ERASE=0, EXPOSE=1, CONVERT=2, READ=3, IDLE=4;

   logic               convert;
   logic               convert_stop;
   logic [2:0]         state,next_state;   //States
   integer           counter;            //Delay counter in state machine

   //State duration in clock cycles
   parameter integer c_erase = 5;
   parameter integer c_expose = 255;
   parameter integer c_convert = 255;
   parameter integer c_read = 5;

   // Control the output signals
   always_ff @(negedge clk ) begin
      case(state)
        ERASE: begin
           erase <= 1;
           read <= 0;
           expose <= 0;
           convert <= 0;
        end
        EXPOSE: begin
           erase <= 0;
           read <= 0;
           expose <= 1;
           convert <= 0;
        end
        CONVERT: begin
           erase <= 0;
           read <= 0;
           expose <= 0;
           convert = 1;
        end
        READ: begin
           erase <= 0;
           read <= 1;
           expose <= 0;
           convert <= 0;
        end
        IDLE: begin
           erase <= 0;
           read <= 0;
           expose <= 0;
           convert <= 0;

        end
      endcase // case (state)
   end // always @ (state)

   // Control the state transitions
   always_ff @(posedge clk or posedge reset) begin
      if(reset) begin
         state = IDLE;
         next_state = ERASE;
         counter  = 0;
         convert  = 0;
         pixel_counter = 0;
      end
      else begin
         case (state)
           ERASE: begin
              if(counter == c_erase) begin
                 next_state <= EXPOSE;
                 state <= IDLE;
              end
           end
           EXPOSE: begin
              if(counter == c_expose) begin
                 next_state <= CONVERT;
                 state <= IDLE;
              end
           end
           CONVERT: begin
              if(counter == c_convert) begin
                 next_state <= READ;
                 state <= IDLE;
              end
           end
           READ:
             if(counter == c_read) begin
                state <= IDLE;
                next_state <= ERASE;
             end
           IDLE:
             state <= next_state;
         endcase // case (state)
         if(state == IDLE)
           counter = 0;
         else
           counter = counter + 1;
      end
   end // always @ (posedge clk or posedge reset)

   //------------------------------------------------------------
   // DAC and ADC model
   //------------------------------------------------------------
   logic [PIXEL_ARRAY_WIDTH-1:0][7:0] data;


   // If we are to convert, then provide a clock via anaRamp
   // This does not model the real world behavior, as anaRamp would be a voltage from the ADC
   // however, we cheat
   assign analog_ramp = convert ? clk : 0;

   // During expoure, provide a clock via anaBias1.
   // Again, no resemblence to real world, but we cheat.
   assign analog_bias = expose ? clk : 0;

   // If we're not reading the pixData, then we should drive the bus
//    assign rowData = read ? 8'bZ : data;

   // When convert, then run a analog ramp (via anaRamp clock) and digtal ramp via
   // data bus. Assert convert_stop to return control to main state machine.
   always_ff @(posedge clk or posedge reset) begin
      if(reset) begin
         data =0;
      end
      if(convert) begin
         pixel_counter +=  1;
      end
      else begin
         pixel_counter = 0;
      end
   end // always @ (posedge clk or reset)

   //------------------------------------------------------------
   // Readout from databus
   //------------------------------------------------------------
   logic [PIXEL_ARRAY_WIDTH-1:0][7:0] rowDataOut;
   always_ff @(posedge clk or posedge reset) begin
      if(reset) begin
         rowDataOut = 0;
      end
      else begin
         if(read)
           rowDataOut <= rowData;
      end
   end

    initial begin

        reset = 1;

        #clk_period  reset=0;

        $dumpfile("pixelRow_tb.vcd");
        $dumpvars(0,pixelRow_tb);

        #sim_end
          $stop;
    end
endmodule