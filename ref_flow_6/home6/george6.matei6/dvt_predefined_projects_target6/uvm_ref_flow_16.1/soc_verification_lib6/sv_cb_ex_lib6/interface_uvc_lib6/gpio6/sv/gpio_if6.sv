/*-------------------------------------------------------------------------
File6 name   : gpio_if6.sv
Title6       : GPIO6 SystemVerilog6 UVM UVC6
Project6     : SystemVerilog6 UVM Cluster6 Level6 Verification6
Created6     :
Description6 : 
Notes6       :  
---------------------------------------------------------------------------*/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------


interface gpio_if6();

  // Control6 flags6
  bit                has_checks6 = 1;
  bit                has_coverage = 1;

  // Actual6 Signals6
  // APB6 Slave6 Interface6 - inputs6
  logic              pclk6;
  logic              n_p_reset6;

  // Slave6 GPIO6 Interface6 - inputs6
  logic [`GPIO_DATA_WIDTH6-1:0]       n_gpio_pin_oe6;
  logic [`GPIO_DATA_WIDTH6-1:0]       gpio_pin_out6;
  logic [`GPIO_DATA_WIDTH6-1:0]       gpio_pin_in6;

// Coverage6 and assertions6 to be implemented here6.

/*
always @(negedge sig_pclk6)
begin

// Read and write never true6 at the same time
assertReadOrWrite6: assert property (
                   disable iff(!has_checks6) 
                   ($onehot(sig_grant6) |-> !(sig_read6 && sig_write6)))
                   else
                     $error("ERR_READ_OR_WRITE6\n Read and Write true6 at \
                             the same time");

end
*/

endinterface : gpio_if6

