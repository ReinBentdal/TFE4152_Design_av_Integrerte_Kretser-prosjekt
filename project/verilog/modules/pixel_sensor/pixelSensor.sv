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

`timescale 1 ns / 1 ps

module PIXEL_SENSOR
  (
   input logic      VBN1,
   input logic      RAMP,
   input logic      ERASE,
   input logic      EXPOSE,
   input logic      READ,
   input [PIXEL_BITS-1:0] COUNTER,
   output [PIXEL_BITS-1:0] DATA
   );

   import PixelSensorConfig::PIXEL_BITS;
   import PixelSensorConfig::PIXEL_ARRAY_WIDTH;
   import PixelSensorConfig::PIXEL_ARRAY_HEIGHT;

   parameter integer width_index = 0;
   parameter integer height_index = 0;

   logic            cmp;
   logic [PIXEL_BITS-1:0]      p_data;

      //----------------------------------------------------------------
   // Memory latch
   //----------------------------------------------------------------
   always_ff @(posedge cmp)  begin
      p_data = COUNTER;
   end

   //----------------------------------------------------------------
   // Readout
   //----------------------------------------------------------------
   // Assign data to bus when pixRead = 0
   // Antar at når READ kalles så er p_data satt
   assign DATA = READ ? p_data : 8'bZ;

   //----------------------------------------------------------------
   // Non synthesize-able
   //----------------------------------------------------------------
`ifndef synthesize
   import PixelSensorConfig::SCENE;

   parameter real             v_erase = 1.2;

   // hvor mye spenning per steg
   parameter real             lsb = v_erase/(2**PIXEL_BITS);
   
   real             tmp;
   real             adc;
   real light_intensity;


   //----------------------------------------------------------------
   // ERASE
   //----------------------------------------------------------------
   // Reset the pixel value on pixRst
   always_ff @(posedge ERASE) begin
      tmp = v_erase;
      p_data = 0;
      cmp  = 0;
      adc = 0;
   end

   //----------------------------------------------------------------
   // SENSOR
   //----------------------------------------------------------------
   // Use bias to provide a clock for integration when exposing
   always_ff @(posedge VBN1) begin
      if(EXPOSE) begin
         light_intensity = real'(SCENE[height_index][width_index])/real'(2**PIXEL_BITS);
         tmp = tmp - light_intensity*lsb;
      end
   end

   //----------------------------------------------------------------
   // Comparator
   //----------------------------------------------------------------
   // Use ramp to provide a clock for ADC conversion, assume that ramp
   // and COUNTER are synchronous
   always_ff @(posedge RAMP) begin
      adc = adc + lsb;
      if(adc > tmp) // TODO: mulig å fjerne compare
        cmp <= 1;
   end

`endif

endmodule // re_control
