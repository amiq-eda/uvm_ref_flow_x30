/*-------------------------------------------------------------------------
File3 name   : gpio_if3.sv
Title3       : GPIO3 SystemVerilog3 UVM UVC3
Project3     : SystemVerilog3 UVM Cluster3 Level3 Verification3
Created3     :
Description3 : 
Notes3       :  
---------------------------------------------------------------------------*/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------


interface gpio_if3();

  // Control3 flags3
  bit                has_checks3 = 1;
  bit                has_coverage = 1;

  // Actual3 Signals3
  // APB3 Slave3 Interface3 - inputs3
  logic              pclk3;
  logic              n_p_reset3;

  // Slave3 GPIO3 Interface3 - inputs3
  logic [`GPIO_DATA_WIDTH3-1:0]       n_gpio_pin_oe3;
  logic [`GPIO_DATA_WIDTH3-1:0]       gpio_pin_out3;
  logic [`GPIO_DATA_WIDTH3-1:0]       gpio_pin_in3;

// Coverage3 and assertions3 to be implemented here3.

/*
always @(negedge sig_pclk3)
begin

// Read and write never true3 at the same time
assertReadOrWrite3: assert property (
                   disable iff(!has_checks3) 
                   ($onehot(sig_grant3) |-> !(sig_read3 && sig_write3)))
                   else
                     $error("ERR_READ_OR_WRITE3\n Read and Write true3 at \
                             the same time");

end
*/

endinterface : gpio_if3

