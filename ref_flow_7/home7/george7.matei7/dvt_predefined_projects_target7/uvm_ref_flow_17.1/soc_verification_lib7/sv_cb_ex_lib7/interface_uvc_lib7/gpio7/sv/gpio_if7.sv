/*-------------------------------------------------------------------------
File7 name   : gpio_if7.sv
Title7       : GPIO7 SystemVerilog7 UVM UVC7
Project7     : SystemVerilog7 UVM Cluster7 Level7 Verification7
Created7     :
Description7 : 
Notes7       :  
---------------------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------


interface gpio_if7();

  // Control7 flags7
  bit                has_checks7 = 1;
  bit                has_coverage = 1;

  // Actual7 Signals7
  // APB7 Slave7 Interface7 - inputs7
  logic              pclk7;
  logic              n_p_reset7;

  // Slave7 GPIO7 Interface7 - inputs7
  logic [`GPIO_DATA_WIDTH7-1:0]       n_gpio_pin_oe7;
  logic [`GPIO_DATA_WIDTH7-1:0]       gpio_pin_out7;
  logic [`GPIO_DATA_WIDTH7-1:0]       gpio_pin_in7;

// Coverage7 and assertions7 to be implemented here7.

/*
always @(negedge sig_pclk7)
begin

// Read and write never true7 at the same time
assertReadOrWrite7: assert property (
                   disable iff(!has_checks7) 
                   ($onehot(sig_grant7) |-> !(sig_read7 && sig_write7)))
                   else
                     $error("ERR_READ_OR_WRITE7\n Read and Write true7 at \
                             the same time");

end
*/

endinterface : gpio_if7

