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


module PIXEL_SENSOR
  (
   input logic      VBN1,
   input logic      RAMP,
   input logic      RESET,
   input logic      ERASE,
   input logic      EXPOSE,
   input logic      READ,
   input [7:0] COUNTER,
   output [7:0] DATA
   );

   real             v_erase = 1.2;

   // hvor mye spenning per steg
   real             lsb = v_erase/255;
   
   // lysintensitet
   parameter real   dv_pixel = 0.5;

   real             tmp;
   logic            cmp;
   real             adc;

   logic [7:0]      p_data;

   //----------------------------------------------------------------
   // ERASE
   //----------------------------------------------------------------
   // Reset the pixel value on pixRst
   always @(ERASE) begin
      tmp = v_erase;
      p_data = 0;
      cmp  = 0;
      adc = 0;
   end

   //----------------------------------------------------------------
   // SENSOR
   //----------------------------------------------------------------
   // Use bias to provide a clock for integration when exposing
   always @(posedge VBN1) begin
      if(EXPOSE)
        tmp = tmp - dv_pixel*lsb;
   end

   //----------------------------------------------------------------
   // Comparator
   //----------------------------------------------------------------
   // Use ramp to provide a clock for ADC conversion, assume that ramp
   // and COUNTER are synchronous
   always @(posedge RAMP) begin
      adc = adc + lsb;
      if(adc > tmp) // TODO: mulig å fjerne compare
        cmp <= 1;
   end

   //----------------------------------------------------------------
   // Memory latch
   //----------------------------------------------------------------
   always_comb  begin
      if(!cmp) begin
         p_data = COUNTER;
      end
   end

   //----------------------------------------------------------------
   // Readout
   //----------------------------------------------------------------
   // Assign data to bus when pixRead = 0
   // Antar at når READ kalles så er p_data satt
   assign DATA = READ ? p_data : 8'bZ;

endmodule // re_control
