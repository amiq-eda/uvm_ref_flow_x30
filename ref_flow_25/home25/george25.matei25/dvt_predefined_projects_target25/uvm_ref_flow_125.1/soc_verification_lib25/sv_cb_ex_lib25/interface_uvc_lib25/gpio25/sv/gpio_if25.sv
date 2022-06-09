/*-------------------------------------------------------------------------
File25 name   : gpio_if25.sv
Title25       : GPIO25 SystemVerilog25 UVM UVC25
Project25     : SystemVerilog25 UVM Cluster25 Level25 Verification25
Created25     :
Description25 : 
Notes25       :  
---------------------------------------------------------------------------*/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------


interface gpio_if25();

  // Control25 flags25
  bit                has_checks25 = 1;
  bit                has_coverage = 1;

  // Actual25 Signals25
  // APB25 Slave25 Interface25 - inputs25
  logic              pclk25;
  logic              n_p_reset25;

  // Slave25 GPIO25 Interface25 - inputs25
  logic [`GPIO_DATA_WIDTH25-1:0]       n_gpio_pin_oe25;
  logic [`GPIO_DATA_WIDTH25-1:0]       gpio_pin_out25;
  logic [`GPIO_DATA_WIDTH25-1:0]       gpio_pin_in25;

// Coverage25 and assertions25 to be implemented here25.

/*
always @(negedge sig_pclk25)
begin

// Read and write never true25 at the same time
assertReadOrWrite25: assert property (
                   disable iff(!has_checks25) 
                   ($onehot(sig_grant25) |-> !(sig_read25 && sig_write25)))
                   else
                     $error("ERR_READ_OR_WRITE25\n Read and Write true25 at \
                             the same time");

end
*/

endinterface : gpio_if25

