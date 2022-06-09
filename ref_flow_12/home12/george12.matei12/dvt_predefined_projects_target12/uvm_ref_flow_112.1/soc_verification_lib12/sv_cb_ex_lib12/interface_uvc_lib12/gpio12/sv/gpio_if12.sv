/*-------------------------------------------------------------------------
File12 name   : gpio_if12.sv
Title12       : GPIO12 SystemVerilog12 UVM UVC12
Project12     : SystemVerilog12 UVM Cluster12 Level12 Verification12
Created12     :
Description12 : 
Notes12       :  
---------------------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------


interface gpio_if12();

  // Control12 flags12
  bit                has_checks12 = 1;
  bit                has_coverage = 1;

  // Actual12 Signals12
  // APB12 Slave12 Interface12 - inputs12
  logic              pclk12;
  logic              n_p_reset12;

  // Slave12 GPIO12 Interface12 - inputs12
  logic [`GPIO_DATA_WIDTH12-1:0]       n_gpio_pin_oe12;
  logic [`GPIO_DATA_WIDTH12-1:0]       gpio_pin_out12;
  logic [`GPIO_DATA_WIDTH12-1:0]       gpio_pin_in12;

// Coverage12 and assertions12 to be implemented here12.

/*
always @(negedge sig_pclk12)
begin

// Read and write never true12 at the same time
assertReadOrWrite12: assert property (
                   disable iff(!has_checks12) 
                   ($onehot(sig_grant12) |-> !(sig_read12 && sig_write12)))
                   else
                     $error("ERR_READ_OR_WRITE12\n Read and Write true12 at \
                             the same time");

end
*/

endinterface : gpio_if12

