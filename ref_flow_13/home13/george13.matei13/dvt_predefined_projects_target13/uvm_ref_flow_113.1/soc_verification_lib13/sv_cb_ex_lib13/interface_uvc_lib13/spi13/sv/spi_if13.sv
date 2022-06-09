/*-------------------------------------------------------------------------
File13 name   : spi_if13.sv
Title13       : SPI13 SystemVerilog13 UVM UVC13
Project13     : SystemVerilog13 UVM Cluster13 Level13 Verification13
Created13     :
Description13 : 
Notes13       :  
---------------------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------


interface spi_if13();

  // Control13 flags13
  bit                has_checks13 = 1;
  bit                has_coverage = 1;

  // Actual13 Signals13
  // APB13 Slave13 Interface13 - inputs13
  logic              sig_pclk13;
  logic              sig_n_p_reset13;

  // Slave13 SPI13 Interface13 - inputs13
  logic              sig_si13;                //MOSI13, Slave13 input
  logic              sig_sclk_in13;
  logic              sig_n_ss_in13;
  logic              sig_slave_in_clk13;
  // Slave13 SPI13 Interface13 - outputs13
  logic              sig_slave_out_clk13;
  logic              sig_n_so_en13;          //MISO13, Output13 enable
  logic              sig_so13;               //MISO13, Slave13 output


  // Master13 SPI13 Interface13 - inputs13
  logic              sig_mi13;               //MISO13, Master13 input
  logic              sig_ext_clk13;
  // Master13 SPI13 Interface13 - outputs13
  logic              sig_n_ss_en13;
  logic        [3:0] sig_n_ss_out13;
  logic              sig_n_sclk_en13;
  logic              sig_sclk_out13;
  logic              sig_n_mo_en13;          //MOSI13, Output13 enable
  logic              sig_mo13;               //MOSI13, Master13 input

// Coverage13 and assertions13 to be implemented here13.

/*
always @(negedge sig_pclk13)
begin

// Read and write never true13 at the same time
assertReadOrWrite13: assert property (
                   disable iff(!has_checks13) 
                   ($onehot(sig_grant13) |-> !(sig_read13 && sig_write13)))
                   else
                     $error("ERR_READ_OR_WRITE13\n Read and Write true13 at \
                             the same time");

end
*/

endinterface : spi_if13

