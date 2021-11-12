`include "../../pixel_sensor_config.sv"
`include "../../components/counter.sv"

// Simulation of analog part of the sensor. 
// synthesizable dummy-sensor for testing the rest of the synthesizable circuits
// This is completely different from how the analog circuit actually would work.
// This does not simulate the expose part, as the expose value is fixed in expose_value
module PIXEL_SENSOR_ANALOG(
   input EXPOSE,
   input RAMP,
   input ERASE,
   output logic CMP
);

   parameter integer width_index = 0;
   parameter integer height_index = 0;

   import PixelSensorConfig::PIXEL_ARRAY_WIDTH;
   import PixelSensorConfig::PIXEL_ARRAY_HEIGHT;
   import PixelSensorConfig::SCENE_24;
   import PixelSensorConfig::SCENE;
   import PixelSensorConfig::PIXEL_BITS;

   // create some pattern which is recognizable when simulated.
   // Use this for 24x24 simulations
   parameter logic [PIXEL_BITS-1:0] expose_value = 255 - SCENE_24[8*(width_index + (height_index*24)) +: 8];
   
   // Use this for large simulations
   // logic [PIXEL_BITS-1:0] expose_value;
   // assign expose_value = PIXEL_BITS'(255) - PIXEL_BITS'(SCENE[height_index][width_index]); // larger simulations

   // simulation view value
   logic [7:0] EXPOSE_VALUE;
   assign EXPOSE_VALUE = expose_value;

   logic [7:0] expose_cmp;

   Counter #(.bits(8)) Counter(
      .clk(RAMP),
      .reset(ERASE),
      .enable(1'b1),
      .out(expose_cmp)
   );

   always_ff @( posedge RAMP or posedge ERASE ) begin
      if (ERASE)
         CMP <= 0;
      else if (expose_cmp == expose_value)
         CMP <= 1;
   end

endmodule