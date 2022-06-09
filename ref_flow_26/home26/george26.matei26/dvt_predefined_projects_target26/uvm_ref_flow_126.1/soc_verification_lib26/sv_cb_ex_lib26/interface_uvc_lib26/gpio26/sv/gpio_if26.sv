/*-------------------------------------------------------------------------
File26 name   : gpio_if26.sv
Title26       : GPIO26 SystemVerilog26 UVM UVC26
Project26     : SystemVerilog26 UVM Cluster26 Level26 Verification26
Created26     :
Description26 : 
Notes26       :  
---------------------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


interface gpio_if26();

  // Control26 flags26
  bit                has_checks26 = 1;
  bit                has_coverage = 1;

  // Actual26 Signals26
  // APB26 Slave26 Interface26 - inputs26
  logic              pclk26;
  logic              n_p_reset26;

  // Slave26 GPIO26 Interface26 - inputs26
  logic [`GPIO_DATA_WIDTH26-1:0]       n_gpio_pin_oe26;
  logic [`GPIO_DATA_WIDTH26-1:0]       gpio_pin_out26;
  logic [`GPIO_DATA_WIDTH26-1:0]       gpio_pin_in26;

// Coverage26 and assertions26 to be implemented here26.

/*
always @(negedge sig_pclk26)
begin

// Read and write never true26 at the same time
assertReadOrWrite26: assert property (
                   disable iff(!has_checks26) 
                   ($onehot(sig_grant26) |-> !(sig_read26 && sig_write26)))
                   else
                     $error("ERR_READ_OR_WRITE26\n Read and Write true26 at \
                             the same time");

end
*/

endinterface : gpio_if26

