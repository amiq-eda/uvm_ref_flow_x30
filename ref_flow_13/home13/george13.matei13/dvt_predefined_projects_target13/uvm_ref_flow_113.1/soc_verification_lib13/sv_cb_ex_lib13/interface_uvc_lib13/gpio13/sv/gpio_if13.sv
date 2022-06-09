/*-------------------------------------------------------------------------
File13 name   : gpio_if13.sv
Title13       : GPIO13 SystemVerilog13 UVM UVC13
Project13     : SystemVerilog13 UVM Cluster13 Level13 Verification13
Created13     :
Description13 : 
Notes13       :  
---------------------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------


interface gpio_if13();

  // Control13 flags13
  bit                has_checks13 = 1;
  bit                has_coverage = 1;

  // Actual13 Signals13
  // APB13 Slave13 Interface13 - inputs13
  logic              pclk13;
  logic              n_p_reset13;

  // Slave13 GPIO13 Interface13 - inputs13
  logic [`GPIO_DATA_WIDTH13-1:0]       n_gpio_pin_oe13;
  logic [`GPIO_DATA_WIDTH13-1:0]       gpio_pin_out13;
  logic [`GPIO_DATA_WIDTH13-1:0]       gpio_pin_in13;

// Coverage13 and assertions13 to be implemented here13.

/*
always @(negedge sig_pclk13)
begin

// Read and write never true13 at the same time
assertReadOrWrite13: assert property (
                   disable iff(!has_checks13) 
                   ($onehot(sig_grant13) |-> !(sig_read13 && sig_write13)))
                   else
                     $error("ERR_READ_OR_WRITE13\n Read and Write true13 at \
                             the same time");

end
*/

endinterface : gpio_if13

