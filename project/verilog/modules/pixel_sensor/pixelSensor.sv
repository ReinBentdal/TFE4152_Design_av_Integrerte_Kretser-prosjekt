//====================================================================
//        Copyright (c) 2021 Carsten Wulff Software, Norway
// ===================================================================
// Created       : wulff at 2021-7-21
// ===================================================================
//  The MIT License (MIT)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//====================================================================

//----------------------------------------------------------------
// Model of pixel sensor, including
//  - Reset
//  - The sensor
//  - Comparator
//  - Memory latch
//  - Readout of latched value
//----------------------------------------------------------------

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
