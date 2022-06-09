/*-------------------------------------------------------------------------
File17 name   : spi_if17.sv
Title17       : SPI17 SystemVerilog17 UVM UVC17
Project17     : SystemVerilog17 UVM Cluster17 Level17 Verification17
Created17     :
Description17 : 
Notes17       :  
---------------------------------------------------------------------------*/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------


interface spi_if17();

  // Control17 flags17
  bit                has_checks17 = 1;
  bit                has_coverage = 1;

  // Actual17 Signals17
  // APB17 Slave17 Interface17 - inputs17
  logic              sig_pclk17;
  logic              sig_n_p_reset17;

  // Slave17 SPI17 Interface17 - inputs17
  logic              sig_si17;                //MOSI17, Slave17 input
  logic              sig_sclk_in17;
  logic              sig_n_ss_in17;
  logic              sig_slave_in_clk17;
  // Slave17 SPI17 Interface17 - outputs17
  logic              sig_slave_out_clk17;
  logic              sig_n_so_en17;          //MISO17, Output17 enable
  logic              sig_so17;               //MISO17, Slave17 output


  // Master17 SPI17 Interface17 - inputs17
  logic              sig_mi17;               //MISO17, Master17 input
  logic              sig_ext_clk17;
  // Master17 SPI17 Interface17 - outputs17
  logic              sig_n_ss_en17;
  logic        [3:0] sig_n_ss_out17;
  logic              sig_n_sclk_en17;
  logic              sig_sclk_out17;
  logic              sig_n_mo_en17;          //MOSI17, Output17 enable
  logic              sig_mo17;               //MOSI17, Master17 input

// Coverage17 and assertions17 to be implemented here17.

/*
always @(negedge sig_pclk17)
begin

// Read and write never true17 at the same time
assertReadOrWrite17: assert property (
                   disable iff(!has_checks17) 
                   ($onehot(sig_grant17) |-> !(sig_read17 && sig_write17)))
                   else
                     $error("ERR_READ_OR_WRITE17\n Read and Write true17 at \
                             the same time");

end
*/

endinterface : spi_if17

