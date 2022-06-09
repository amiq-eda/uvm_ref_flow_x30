/*-------------------------------------------------------------------------
File16 name   : spi_if16.sv
Title16       : SPI16 SystemVerilog16 UVM UVC16
Project16     : SystemVerilog16 UVM Cluster16 Level16 Verification16
Created16     :
Description16 : 
Notes16       :  
---------------------------------------------------------------------------*/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------


interface spi_if16();

  // Control16 flags16
  bit                has_checks16 = 1;
  bit                has_coverage = 1;

  // Actual16 Signals16
  // APB16 Slave16 Interface16 - inputs16
  logic              sig_pclk16;
  logic              sig_n_p_reset16;

  // Slave16 SPI16 Interface16 - inputs16
  logic              sig_si16;                //MOSI16, Slave16 input
  logic              sig_sclk_in16;
  logic              sig_n_ss_in16;
  logic              sig_slave_in_clk16;
  // Slave16 SPI16 Interface16 - outputs16
  logic              sig_slave_out_clk16;
  logic              sig_n_so_en16;          //MISO16, Output16 enable
  logic              sig_so16;               //MISO16, Slave16 output


  // Master16 SPI16 Interface16 - inputs16
  logic              sig_mi16;               //MISO16, Master16 input
  logic              sig_ext_clk16;
  // Master16 SPI16 Interface16 - outputs16
  logic              sig_n_ss_en16;
  logic        [3:0] sig_n_ss_out16;
  logic              sig_n_sclk_en16;
  logic              sig_sclk_out16;
  logic              sig_n_mo_en16;          //MOSI16, Output16 enable
  logic              sig_mo16;               //MOSI16, Master16 input

// Coverage16 and assertions16 to be implemented here16.

/*
always @(negedge sig_pclk16)
begin

// Read and write never true16 at the same time
assertReadOrWrite16: assert property (
                   disable iff(!has_checks16) 
                   ($onehot(sig_grant16) |-> !(sig_read16 && sig_write16)))
                   else
                     $error("ERR_READ_OR_WRITE16\n Read and Write true16 at \
                             the same time");

end
*/

endinterface : spi_if16

