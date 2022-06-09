/*-------------------------------------------------------------------------
File1 name   : gpio_if1.sv
Title1       : GPIO1 SystemVerilog1 UVM UVC1
Project1     : SystemVerilog1 UVM Cluster1 Level1 Verification1
Created1     :
Description1 : 
Notes1       :  
---------------------------------------------------------------------------*/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------


interface gpio_if1();

  // Control1 flags1
  bit                has_checks1 = 1;
  bit                has_coverage = 1;

  // Actual1 Signals1
  // APB1 Slave1 Interface1 - inputs1
  logic              pclk1;
  logic              n_p_reset1;

  // Slave1 GPIO1 Interface1 - inputs1
  logic [`GPIO_DATA_WIDTH1-1:0]       n_gpio_pin_oe1;
  logic [`GPIO_DATA_WIDTH1-1:0]       gpio_pin_out1;
  logic [`GPIO_DATA_WIDTH1-1:0]       gpio_pin_in1;

// Coverage1 and assertions1 to be implemented here1.

/*
always @(negedge sig_pclk1)
begin

// Read and write never true1 at the same time
assertReadOrWrite1: assert property (
                   disable iff(!has_checks1) 
                   ($onehot(sig_grant1) |-> !(sig_read1 && sig_write1)))
                   else
                     $error("ERR_READ_OR_WRITE1\n Read and Write true1 at \
                             the same time");

end
*/

endinterface : gpio_if1

