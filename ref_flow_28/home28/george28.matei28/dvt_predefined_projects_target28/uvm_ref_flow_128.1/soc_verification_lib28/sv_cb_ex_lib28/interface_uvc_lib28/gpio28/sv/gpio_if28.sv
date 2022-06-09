/*-------------------------------------------------------------------------
File28 name   : gpio_if28.sv
Title28       : GPIO28 SystemVerilog28 UVM UVC28
Project28     : SystemVerilog28 UVM Cluster28 Level28 Verification28
Created28     :
Description28 : 
Notes28       :  
---------------------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------


interface gpio_if28();

  // Control28 flags28
  bit                has_checks28 = 1;
  bit                has_coverage = 1;

  // Actual28 Signals28
  // APB28 Slave28 Interface28 - inputs28
  logic              pclk28;
  logic              n_p_reset28;

  // Slave28 GPIO28 Interface28 - inputs28
  logic [`GPIO_DATA_WIDTH28-1:0]       n_gpio_pin_oe28;
  logic [`GPIO_DATA_WIDTH28-1:0]       gpio_pin_out28;
  logic [`GPIO_DATA_WIDTH28-1:0]       gpio_pin_in28;

// Coverage28 and assertions28 to be implemented here28.

/*
always @(negedge sig_pclk28)
begin

// Read and write never true28 at the same time
assertReadOrWrite28: assert property (
                   disable iff(!has_checks28) 
                   ($onehot(sig_grant28) |-> !(sig_read28 && sig_write28)))
                   else
                     $error("ERR_READ_OR_WRITE28\n Read and Write true28 at \
                             the same time");

end
*/

endinterface : gpio_if28

