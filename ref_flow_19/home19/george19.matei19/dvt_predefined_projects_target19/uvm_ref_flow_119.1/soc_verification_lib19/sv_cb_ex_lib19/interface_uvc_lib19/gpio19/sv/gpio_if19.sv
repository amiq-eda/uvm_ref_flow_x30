/*-------------------------------------------------------------------------
File19 name   : gpio_if19.sv
Title19       : GPIO19 SystemVerilog19 UVM UVC19
Project19     : SystemVerilog19 UVM Cluster19 Level19 Verification19
Created19     :
Description19 : 
Notes19       :  
---------------------------------------------------------------------------*/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------


interface gpio_if19();

  // Control19 flags19
  bit                has_checks19 = 1;
  bit                has_coverage = 1;

  // Actual19 Signals19
  // APB19 Slave19 Interface19 - inputs19
  logic              pclk19;
  logic              n_p_reset19;

  // Slave19 GPIO19 Interface19 - inputs19
  logic [`GPIO_DATA_WIDTH19-1:0]       n_gpio_pin_oe19;
  logic [`GPIO_DATA_WIDTH19-1:0]       gpio_pin_out19;
  logic [`GPIO_DATA_WIDTH19-1:0]       gpio_pin_in19;

// Coverage19 and assertions19 to be implemented here19.

/*
always @(negedge sig_pclk19)
begin

// Read and write never true19 at the same time
assertReadOrWrite19: assert property (
                   disable iff(!has_checks19) 
                   ($onehot(sig_grant19) |-> !(sig_read19 && sig_write19)))
                   else
                     $error("ERR_READ_OR_WRITE19\n Read and Write true19 at \
                             the same time");

end
*/

endinterface : gpio_if19

