/*-------------------------------------------------------------------------
File24 name   : spi_if24.sv
Title24       : SPI24 SystemVerilog24 UVM UVC24
Project24     : SystemVerilog24 UVM Cluster24 Level24 Verification24
Created24     :
Description24 : 
Notes24       :  
---------------------------------------------------------------------------*/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------


interface spi_if24();

  // Control24 flags24
  bit                has_checks24 = 1;
  bit                has_coverage = 1;

  // Actual24 Signals24
  // APB24 Slave24 Interface24 - inputs24
  logic              sig_pclk24;
  logic              sig_n_p_reset24;

  // Slave24 SPI24 Interface24 - inputs24
  logic              sig_si24;                //MOSI24, Slave24 input
  logic              sig_sclk_in24;
  logic              sig_n_ss_in24;
  logic              sig_slave_in_clk24;
  // Slave24 SPI24 Interface24 - outputs24
  logic              sig_slave_out_clk24;
  logic              sig_n_so_en24;          //MISO24, Output24 enable
  logic              sig_so24;               //MISO24, Slave24 output


  // Master24 SPI24 Interface24 - inputs24
  logic              sig_mi24;               //MISO24, Master24 input
  logic              sig_ext_clk24;
  // Master24 SPI24 Interface24 - outputs24
  logic              sig_n_ss_en24;
  logic        [3:0] sig_n_ss_out24;
  logic              sig_n_sclk_en24;
  logic              sig_sclk_out24;
  logic              sig_n_mo_en24;          //MOSI24, Output24 enable
  logic              sig_mo24;               //MOSI24, Master24 input

// Coverage24 and assertions24 to be implemented here24.

/*
always @(negedge sig_pclk24)
begin

// Read and write never true24 at the same time
assertReadOrWrite24: assert property (
                   disable iff(!has_checks24) 
                   ($onehot(sig_grant24) |-> !(sig_read24 && sig_write24)))
                   else
                     $error("ERR_READ_OR_WRITE24\n Read and Write true24 at \
                             the same time");

end
*/

endinterface : spi_if24

