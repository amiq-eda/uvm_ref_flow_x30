/*-------------------------------------------------------------------------
File21 name   : gpio_if21.sv
Title21       : GPIO21 SystemVerilog21 UVM UVC21
Project21     : SystemVerilog21 UVM Cluster21 Level21 Verification21
Created21     :
Description21 : 
Notes21       :  
---------------------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------


interface gpio_if21();

  // Control21 flags21
  bit                has_checks21 = 1;
  bit                has_coverage = 1;

  // Actual21 Signals21
  // APB21 Slave21 Interface21 - inputs21
  logic              pclk21;
  logic              n_p_reset21;

  // Slave21 GPIO21 Interface21 - inputs21
  logic [`GPIO_DATA_WIDTH21-1:0]       n_gpio_pin_oe21;
  logic [`GPIO_DATA_WIDTH21-1:0]       gpio_pin_out21;
  logic [`GPIO_DATA_WIDTH21-1:0]       gpio_pin_in21;

// Coverage21 and assertions21 to be implemented here21.

/*
always @(negedge sig_pclk21)
begin

// Read and write never true21 at the same time
assertReadOrWrite21: assert property (
                   disable iff(!has_checks21) 
                   ($onehot(sig_grant21) |-> !(sig_read21 && sig_write21)))
                   else
                     $error("ERR_READ_OR_WRITE21\n Read and Write true21 at \
                             the same time");

end
*/

endinterface : gpio_if21

