`include "../../pixel_sensor_config.sv"

`ifdef synthesize
`include "../../components/counter.sv"
`endif

// Simulation of analog part of the sensor. 
// The circuit for "synthesize" is there to verify the rest of the design as well as preventing yosys from omitting the entire design
module PIXEL_SENSOR_ANALOG(
   input EXPOSE,
   input RAMP,
   input ERASE,
   output logic CMP
);

   parameter integer width_index = 0;
   parameter integer height_index = 0;

// synthesizable dummy-sensor for testing the rest of the synthesizable circuits
`ifdef synthesize

   import PixelSensorConfig::PIXEL_ARRAY_WIDTH;
   import PixelSensorConfig::PIXEL_ARRAY_HEIGHT;

   // create some pattern which is recognizable when simulated
   parameter integer expose_value = 256 - $ceil(($cos(6.28*(1 + 0.7*width_index + height_index)/(1 + PIXEL_ARRAY_WIDTH + PIXEL_ARRAY_HEIGHT))+1)*128);

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


// non synthesizable code
`else

   import PixelSensorConfig::SCENE;
   import PixelSensorConfig::PIXEL_BITS;
   import PixelSensorConfig::MAIN_CLK_PERIOD;

   localparam real v_erase = 1.2;

   // hvor mye spenning per steg
   parameter real lsb = v_erase/(2**PIXEL_BITS);
   
   real tmp;
   real adc;
   real light_intensity;

   logic expose_clk = 0;
   always #MAIN_CLK_PERIOD expose_clk = ~expose_clk;

   always @(posedge expose_clk) begin
      if (EXPOSE) begin
         light_intensity = real'(SCENE[height_index][width_index])/real'(2**PIXEL_BITS);
         tmp = tmp - light_intensity*lsb;
      end
   end

   always @(posedge RAMP) begin
      adc = adc + lsb;
      if(adc > tmp)
        CMP <= 1;
   end

   always @(posedge ERASE) begin
      tmp <= v_erase;
      CMP  <= 0;
      adc <= 0;
   end
`endif

endmodule