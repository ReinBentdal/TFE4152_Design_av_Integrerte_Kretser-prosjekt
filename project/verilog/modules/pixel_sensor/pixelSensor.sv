`include "../../pixel_sensor_config.sv"
`include "../../components/tristate.sv"
`include "../pixel_sensor/pixelSensorAnalog.sv"

module PIXEL_SENSOR
  (
   input RAMP,
   input ERASE,
   input EXPOSE,
   input READ,
   input [PIXEL_BITS-1:0] COUNTER,
   output [PIXEL_BITS-1:0] DATA
   );

   import PixelSensorConfig::PIXEL_BITS;
   import PixelSensorConfig::PIXEL_ARRAY_WIDTH;
   import PixelSensorConfig::PIXEL_ARRAY_HEIGHT;

   parameter integer width_index = 0;
   parameter integer height_index = 0;

   logic [PIXEL_BITS-1:0] local_data;

   Tristate Tristate[PIXEL_BITS-1:0](
      .A(local_data),
      .EN(READ),
      .Y(DATA)
   );

   logic cmp;

   always_comb begin
      if (!cmp)
         local_data = COUNTER;
   end

   // PIXEL SENSOR and comparator digital model of analog circuit
   PIXEL_SENSOR_ANALOG #(
      .width_index(width_index),
      .height_index(height_index)
   ) PixelSensorAnalog(
      .EXPOSE(EXPOSE),
      .RAMP(RAMP),
      .ERASE(ERASE),
      .CMP(cmp)
   );

endmodule // re_control