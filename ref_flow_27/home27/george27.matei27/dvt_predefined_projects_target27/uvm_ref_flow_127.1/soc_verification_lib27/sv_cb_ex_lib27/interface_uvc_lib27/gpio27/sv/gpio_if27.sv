/*-------------------------------------------------------------------------
File27 name   : gpio_if27.sv
Title27       : GPIO27 SystemVerilog27 UVM UVC27
Project27     : SystemVerilog27 UVM Cluster27 Level27 Verification27
Created27     :
Description27 : 
Notes27       :  
---------------------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


interface gpio_if27();

  // Control27 flags27
  bit                has_checks27 = 1;
  bit                has_coverage = 1;

  // Actual27 Signals27
  // APB27 Slave27 Interface27 - inputs27
  logic              pclk27;
  logic              n_p_reset27;

  // Slave27 GPIO27 Interface27 - inputs27
  logic [`GPIO_DATA_WIDTH27-1:0]       n_gpio_pin_oe27;
  logic [`GPIO_DATA_WIDTH27-1:0]       gpio_pin_out27;
  logic [`GPIO_DATA_WIDTH27-1:0]       gpio_pin_in27;

// Coverage27 and assertions27 to be implemented here27.

/*
always @(negedge sig_pclk27)
begin

// Read and write never true27 at the same time
assertReadOrWrite27: assert property (
                   disable iff(!has_checks27) 
                   ($onehot(sig_grant27) |-> !(sig_read27 && sig_write27)))
                   else
                     $error("ERR_READ_OR_WRITE27\n Read and Write true27 at \
                             the same time");

end
*/

endinterface : gpio_if27

