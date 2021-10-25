`include "pixelArray.sv"

`timescale 1 ns / 1 ps

module pixelArray_tb;

   import PixelSensorConfig::PIXEL_ARRAY_HEIGHT;
   import PixelSensorConfig::PIXEL_ARRAY_WIDTH;
   import PixelSensorConfig::PIXEL_BITS;
   import PixelSensorConfig::MAIN_CLK_PERIOD;

   logic clk = 0;
   logic reset = 0;

   //State duration in clock cycles
   parameter integer c_erase = 5;
   parameter integer c_expose = 255;
   parameter integer c_convert = 255;
   parameter integer c_read_row = 5;
   parameter integer c_read = c_read_row*PIXEL_ARRAY_HEIGHT;

   parameter integer sim_end = MAIN_CLK_PERIOD*2400;

   always #MAIN_CLK_PERIOD clk=~clk;

   logic analog_bias;
   logic analog_ramp;
   logic analog_reset;

   logic erase;
   logic expose;
   logic [PIXEL_ARRAY_HEIGHT-1:0] read;

   logic [7:0] pixel_counter;

   wire [PIXEL_ARRAY_WIDTH-1:0][PIXEL_BITS-1:0] rowData;

   PIXEL_ARRAY pixel_array(
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
   integer           read_counter = 0;

   logic [PIXEL_ARRAY_HEIGHT-1:0] read_register = 1;

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
           read <= read_register;
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
           READ: begin

               if(counter == c_read) begin
                  read_register <= 1;
                  read_counter <= 0;
                  state <= IDLE;
                  next_state <= ERASE;
               end
               else begin
                  read_counter = read_counter + 1;
                  if (read_counter == c_read_row) begin
                     read_register <= read_register << 1;
                     read_counter <= 0;
                  end
               end
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
   logic [PIXEL_ARRAY_WIDTH-1:0][PIXEL_BITS-1:0] data;

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
   logic [PIXEL_ARRAY_WIDTH-1:0][PIXEL_BITS-1:0] rowDataOut;
   always_ff @(posedge clk or posedge reset) begin
      if(reset) begin
         rowDataOut = 0;
      end
      else begin
         if(read != 0)
           rowDataOut <= rowData;
      end
   end

    initial begin

        reset = 1;

        #MAIN_CLK_PERIOD  reset=0;

        $dumpfile("pixelArray_tb.vcd");
        $dumpvars(0,pixelArray_tb);

        #sim_end
          $stop;
    end
endmodule