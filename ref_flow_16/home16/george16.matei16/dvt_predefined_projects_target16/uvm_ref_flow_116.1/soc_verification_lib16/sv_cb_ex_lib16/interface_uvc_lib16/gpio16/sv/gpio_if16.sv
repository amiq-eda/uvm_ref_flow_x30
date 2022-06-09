/*-------------------------------------------------------------------------
File16 name   : gpio_if16.sv
Title16       : GPIO16 SystemVerilog16 UVM UVC16
Project16     : SystemVerilog16 UVM Cluster16 Level16 Verification16
Created16     :
Description16 : 
Notes16       :  
---------------------------------------------------------------------------*/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------


interface gpio_if16();

  // Control16 flags16
  bit                has_checks16 = 1;
  bit                has_coverage = 1;

  // Actual16 Signals16
  // APB16 Slave16 Interface16 - inputs16
  logic              pclk16;
  logic              n_p_reset16;

  // Slave16 GPIO16 Interface16 - inputs16
  logic [`GPIO_DATA_WIDTH16-1:0]       n_gpio_pin_oe16;
  logic [`GPIO_DATA_WIDTH16-1:0]       gpio_pin_out16;
  logic [`GPIO_DATA_WIDTH16-1:0]       gpio_pin_in16;

// Coverage16 and assertions16 to be implemented here16.

/*
always @(negedge sig_pclk16)
begin

// Read and write never true16 at the same time
assertReadOrWrite16: assert property (
                   disable iff(!has_checks16) 
                   ($onehot(sig_grant16) |-> !(sig_read16 && sig_write16)))
                   else
                     $error("ERR_READ_OR_WRITE16\n Read and Write true16 at \
                             the same time");

end
*/

endinterface : gpio_if16

