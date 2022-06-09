/*-------------------------------------------------------------------------
File8 name   : spi_if8.sv
Title8       : SPI8 SystemVerilog8 UVM UVC8
Project8     : SystemVerilog8 UVM Cluster8 Level8 Verification8
Created8     :
Description8 : 
Notes8       :  
---------------------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------


interface spi_if8();

  // Control8 flags8
  bit                has_checks8 = 1;
  bit                has_coverage = 1;

  // Actual8 Signals8
  // APB8 Slave8 Interface8 - inputs8
  logic              sig_pclk8;
  logic              sig_n_p_reset8;

  // Slave8 SPI8 Interface8 - inputs8
  logic              sig_si8;                //MOSI8, Slave8 input
  logic              sig_sclk_in8;
  logic              sig_n_ss_in8;
  logic              sig_slave_in_clk8;
  // Slave8 SPI8 Interface8 - outputs8
  logic              sig_slave_out_clk8;
  logic              sig_n_so_en8;          //MISO8, Output8 enable
  logic              sig_so8;               //MISO8, Slave8 output


  // Master8 SPI8 Interface8 - inputs8
  logic              sig_mi8;               //MISO8, Master8 input
  logic              sig_ext_clk8;
  // Master8 SPI8 Interface8 - outputs8
  logic              sig_n_ss_en8;
  logic        [3:0] sig_n_ss_out8;
  logic              sig_n_sclk_en8;
  logic              sig_sclk_out8;
  logic              sig_n_mo_en8;          //MOSI8, Output8 enable
  logic              sig_mo8;               //MOSI8, Master8 input

// Coverage8 and assertions8 to be implemented here8.

/*
always @(negedge sig_pclk8)
begin

// Read and write never true8 at the same time
assertReadOrWrite8: assert property (
                   disable iff(!has_checks8) 
                   ($onehot(sig_grant8) |-> !(sig_read8 && sig_write8)))
                   else
                     $error("ERR_READ_OR_WRITE8\n Read and Write true8 at \
                             the same time");

end
*/

endinterface : spi_if8

