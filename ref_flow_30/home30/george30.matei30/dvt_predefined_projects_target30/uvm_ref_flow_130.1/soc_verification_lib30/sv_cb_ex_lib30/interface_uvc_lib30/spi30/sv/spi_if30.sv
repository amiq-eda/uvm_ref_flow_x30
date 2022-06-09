/*-------------------------------------------------------------------------
File30 name   : spi_if30.sv
Title30       : SPI30 SystemVerilog30 UVM UVC30
Project30     : SystemVerilog30 UVM Cluster30 Level30 Verification30
Created30     :
Description30 : 
Notes30       :  
---------------------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


interface spi_if30();

  // Control30 flags30
  bit                has_checks30 = 1;
  bit                has_coverage = 1;

  // Actual30 Signals30
  // APB30 Slave30 Interface30 - inputs30
  logic              sig_pclk30;
  logic              sig_n_p_reset30;

  // Slave30 SPI30 Interface30 - inputs30
  logic              sig_si30;                //MOSI30, Slave30 input
  logic              sig_sclk_in30;
  logic              sig_n_ss_in30;
  logic              sig_slave_in_clk30;
  // Slave30 SPI30 Interface30 - outputs30
  logic              sig_slave_out_clk30;
  logic              sig_n_so_en30;          //MISO30, Output30 enable
  logic              sig_so30;               //MISO30, Slave30 output


  // Master30 SPI30 Interface30 - inputs30
  logic              sig_mi30;               //MISO30, Master30 input
  logic              sig_ext_clk30;
  // Master30 SPI30 Interface30 - outputs30
  logic              sig_n_ss_en30;
  logic        [3:0] sig_n_ss_out30;
  logic              sig_n_sclk_en30;
  logic              sig_sclk_out30;
  logic              sig_n_mo_en30;          //MOSI30, Output30 enable
  logic              sig_mo30;               //MOSI30, Master30 input

// Coverage30 and assertions30 to be implemented here30.

/*
always @(negedge sig_pclk30)
begin

// Read and write never true30 at the same time
assertReadOrWrite30: assert property (
                   disable iff(!has_checks30) 
                   ($onehot(sig_grant30) |-> !(sig_read30 && sig_write30)))
                   else
                     $error("ERR_READ_OR_WRITE30\n Read and Write true30 at \
                             the same time");

end
*/

endinterface : spi_if30

