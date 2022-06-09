/*-------------------------------------------------------------------------
File11 name   : spi_if11.sv
Title11       : SPI11 SystemVerilog11 UVM UVC11
Project11     : SystemVerilog11 UVM Cluster11 Level11 Verification11
Created11     :
Description11 : 
Notes11       :  
---------------------------------------------------------------------------*/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------


interface spi_if11();

  // Control11 flags11
  bit                has_checks11 = 1;
  bit                has_coverage = 1;

  // Actual11 Signals11
  // APB11 Slave11 Interface11 - inputs11
  logic              sig_pclk11;
  logic              sig_n_p_reset11;

  // Slave11 SPI11 Interface11 - inputs11
  logic              sig_si11;                //MOSI11, Slave11 input
  logic              sig_sclk_in11;
  logic              sig_n_ss_in11;
  logic              sig_slave_in_clk11;
  // Slave11 SPI11 Interface11 - outputs11
  logic              sig_slave_out_clk11;
  logic              sig_n_so_en11;          //MISO11, Output11 enable
  logic              sig_so11;               //MISO11, Slave11 output


  // Master11 SPI11 Interface11 - inputs11
  logic              sig_mi11;               //MISO11, Master11 input
  logic              sig_ext_clk11;
  // Master11 SPI11 Interface11 - outputs11
  logic              sig_n_ss_en11;
  logic        [3:0] sig_n_ss_out11;
  logic              sig_n_sclk_en11;
  logic              sig_sclk_out11;
  logic              sig_n_mo_en11;          //MOSI11, Output11 enable
  logic              sig_mo11;               //MOSI11, Master11 input

// Coverage11 and assertions11 to be implemented here11.

/*
always @(negedge sig_pclk11)
begin

// Read and write never true11 at the same time
assertReadOrWrite11: assert property (
                   disable iff(!has_checks11) 
                   ($onehot(sig_grant11) |-> !(sig_read11 && sig_write11)))
                   else
                     $error("ERR_READ_OR_WRITE11\n Read and Write true11 at \
                             the same time");

end
*/

endinterface : spi_if11

