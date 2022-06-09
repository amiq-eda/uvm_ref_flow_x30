/*-------------------------------------------------------------------------
File2 name   : gpio_if2.sv
Title2       : GPIO2 SystemVerilog2 UVM UVC2
Project2     : SystemVerilog2 UVM Cluster2 Level2 Verification2
Created2     :
Description2 : 
Notes2       :  
---------------------------------------------------------------------------*/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------


interface gpio_if2();

  // Control2 flags2
  bit                has_checks2 = 1;
  bit                has_coverage = 1;

  // Actual2 Signals2
  // APB2 Slave2 Interface2 - inputs2
  logic              pclk2;
  logic              n_p_reset2;

  // Slave2 GPIO2 Interface2 - inputs2
  logic [`GPIO_DATA_WIDTH2-1:0]       n_gpio_pin_oe2;
  logic [`GPIO_DATA_WIDTH2-1:0]       gpio_pin_out2;
  logic [`GPIO_DATA_WIDTH2-1:0]       gpio_pin_in2;

// Coverage2 and assertions2 to be implemented here2.

/*
always @(negedge sig_pclk2)
begin

// Read and write never true2 at the same time
assertReadOrWrite2: assert property (
                   disable iff(!has_checks2) 
                   ($onehot(sig_grant2) |-> !(sig_read2 && sig_write2)))
                   else
                     $error("ERR_READ_OR_WRITE2\n Read and Write true2 at \
                             the same time");

end
*/

endinterface : gpio_if2

