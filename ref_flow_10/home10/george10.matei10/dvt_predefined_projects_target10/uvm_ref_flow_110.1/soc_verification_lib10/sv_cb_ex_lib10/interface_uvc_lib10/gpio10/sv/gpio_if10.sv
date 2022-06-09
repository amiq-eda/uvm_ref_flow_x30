/*-------------------------------------------------------------------------
File10 name   : gpio_if10.sv
Title10       : GPIO10 SystemVerilog10 UVM UVC10
Project10     : SystemVerilog10 UVM Cluster10 Level10 Verification10
Created10     :
Description10 : 
Notes10       :  
---------------------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------


interface gpio_if10();

  // Control10 flags10
  bit                has_checks10 = 1;
  bit                has_coverage = 1;

  // Actual10 Signals10
  // APB10 Slave10 Interface10 - inputs10
  logic              pclk10;
  logic              n_p_reset10;

  // Slave10 GPIO10 Interface10 - inputs10
  logic [`GPIO_DATA_WIDTH10-1:0]       n_gpio_pin_oe10;
  logic [`GPIO_DATA_WIDTH10-1:0]       gpio_pin_out10;
  logic [`GPIO_DATA_WIDTH10-1:0]       gpio_pin_in10;

// Coverage10 and assertions10 to be implemented here10.

/*
always @(negedge sig_pclk10)
begin

// Read and write never true10 at the same time
assertReadOrWrite10: assert property (
                   disable iff(!has_checks10) 
                   ($onehot(sig_grant10) |-> !(sig_read10 && sig_write10)))
                   else
                     $error("ERR_READ_OR_WRITE10\n Read and Write true10 at \
                             the same time");

end
*/

endinterface : gpio_if10

