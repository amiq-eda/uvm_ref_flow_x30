/*-------------------------------------------------------------------------
File14 name   : gpio_if14.sv
Title14       : GPIO14 SystemVerilog14 UVM UVC14
Project14     : SystemVerilog14 UVM Cluster14 Level14 Verification14
Created14     :
Description14 : 
Notes14       :  
---------------------------------------------------------------------------*/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------


interface gpio_if14();

  // Control14 flags14
  bit                has_checks14 = 1;
  bit                has_coverage = 1;

  // Actual14 Signals14
  // APB14 Slave14 Interface14 - inputs14
  logic              pclk14;
  logic              n_p_reset14;

  // Slave14 GPIO14 Interface14 - inputs14
  logic [`GPIO_DATA_WIDTH14-1:0]       n_gpio_pin_oe14;
  logic [`GPIO_DATA_WIDTH14-1:0]       gpio_pin_out14;
  logic [`GPIO_DATA_WIDTH14-1:0]       gpio_pin_in14;

// Coverage14 and assertions14 to be implemented here14.

/*
always @(negedge sig_pclk14)
begin

// Read and write never true14 at the same time
assertReadOrWrite14: assert property (
                   disable iff(!has_checks14) 
                   ($onehot(sig_grant14) |-> !(sig_read14 && sig_write14)))
                   else
                     $error("ERR_READ_OR_WRITE14\n Read and Write true14 at \
                             the same time");

end
*/

endinterface : gpio_if14

