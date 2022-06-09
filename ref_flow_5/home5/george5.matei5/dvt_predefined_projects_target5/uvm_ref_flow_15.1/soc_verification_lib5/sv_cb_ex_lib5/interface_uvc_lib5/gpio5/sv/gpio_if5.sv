/*-------------------------------------------------------------------------
File5 name   : gpio_if5.sv
Title5       : GPIO5 SystemVerilog5 UVM UVC5
Project5     : SystemVerilog5 UVM Cluster5 Level5 Verification5
Created5     :
Description5 : 
Notes5       :  
---------------------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------


interface gpio_if5();

  // Control5 flags5
  bit                has_checks5 = 1;
  bit                has_coverage = 1;

  // Actual5 Signals5
  // APB5 Slave5 Interface5 - inputs5
  logic              pclk5;
  logic              n_p_reset5;

  // Slave5 GPIO5 Interface5 - inputs5
  logic [`GPIO_DATA_WIDTH5-1:0]       n_gpio_pin_oe5;
  logic [`GPIO_DATA_WIDTH5-1:0]       gpio_pin_out5;
  logic [`GPIO_DATA_WIDTH5-1:0]       gpio_pin_in5;

// Coverage5 and assertions5 to be implemented here5.

/*
always @(negedge sig_pclk5)
begin

// Read and write never true5 at the same time
assertReadOrWrite5: assert property (
                   disable iff(!has_checks5) 
                   ($onehot(sig_grant5) |-> !(sig_read5 && sig_write5)))
                   else
                     $error("ERR_READ_OR_WRITE5\n Read and Write true5 at \
                             the same time");

end
*/

endinterface : gpio_if5

