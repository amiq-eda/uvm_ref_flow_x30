/*-------------------------------------------------------------------------
File20 name   : spi_if20.sv
Title20       : SPI20 SystemVerilog20 UVM UVC20
Project20     : SystemVerilog20 UVM Cluster20 Level20 Verification20
Created20     :
Description20 : 
Notes20       :  
---------------------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------


interface spi_if20();

  // Control20 flags20
  bit                has_checks20 = 1;
  bit                has_coverage = 1;

  // Actual20 Signals20
  // APB20 Slave20 Interface20 - inputs20
  logic              sig_pclk20;
  logic              sig_n_p_reset20;

  // Slave20 SPI20 Interface20 - inputs20
  logic              sig_si20;                //MOSI20, Slave20 input
  logic              sig_sclk_in20;
  logic              sig_n_ss_in20;
  logic              sig_slave_in_clk20;
  // Slave20 SPI20 Interface20 - outputs20
  logic              sig_slave_out_clk20;
  logic              sig_n_so_en20;          //MISO20, Output20 enable
  logic              sig_so20;               //MISO20, Slave20 output


  // Master20 SPI20 Interface20 - inputs20
  logic              sig_mi20;               //MISO20, Master20 input
  logic              sig_ext_clk20;
  // Master20 SPI20 Interface20 - outputs20
  logic              sig_n_ss_en20;
  logic        [3:0] sig_n_ss_out20;
  logic              sig_n_sclk_en20;
  logic              sig_sclk_out20;
  logic              sig_n_mo_en20;          //MOSI20, Output20 enable
  logic              sig_mo20;               //MOSI20, Master20 input

// Coverage20 and assertions20 to be implemented here20.

/*
always @(negedge sig_pclk20)
begin

// Read and write never true20 at the same time
assertReadOrWrite20: assert property (
                   disable iff(!has_checks20) 
                   ($onehot(sig_grant20) |-> !(sig_read20 && sig_write20)))
                   else
                     $error("ERR_READ_OR_WRITE20\n Read and Write true20 at \
                             the same time");

end
*/

endinterface : spi_if20

