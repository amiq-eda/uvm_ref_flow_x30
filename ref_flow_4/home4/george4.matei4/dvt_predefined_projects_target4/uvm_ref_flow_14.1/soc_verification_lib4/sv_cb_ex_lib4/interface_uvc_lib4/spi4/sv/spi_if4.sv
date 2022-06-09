/*-------------------------------------------------------------------------
File4 name   : spi_if4.sv
Title4       : SPI4 SystemVerilog4 UVM UVC4
Project4     : SystemVerilog4 UVM Cluster4 Level4 Verification4
Created4     :
Description4 : 
Notes4       :  
---------------------------------------------------------------------------*/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------


interface spi_if4();

  // Control4 flags4
  bit                has_checks4 = 1;
  bit                has_coverage = 1;

  // Actual4 Signals4
  // APB4 Slave4 Interface4 - inputs4
  logic              sig_pclk4;
  logic              sig_n_p_reset4;

  // Slave4 SPI4 Interface4 - inputs4
  logic              sig_si4;                //MOSI4, Slave4 input
  logic              sig_sclk_in4;
  logic              sig_n_ss_in4;
  logic              sig_slave_in_clk4;
  // Slave4 SPI4 Interface4 - outputs4
  logic              sig_slave_out_clk4;
  logic              sig_n_so_en4;          //MISO4, Output4 enable
  logic              sig_so4;               //MISO4, Slave4 output


  // Master4 SPI4 Interface4 - inputs4
  logic              sig_mi4;               //MISO4, Master4 input
  logic              sig_ext_clk4;
  // Master4 SPI4 Interface4 - outputs4
  logic              sig_n_ss_en4;
  logic        [3:0] sig_n_ss_out4;
  logic              sig_n_sclk_en4;
  logic              sig_sclk_out4;
  logic              sig_n_mo_en4;          //MOSI4, Output4 enable
  logic              sig_mo4;               //MOSI4, Master4 input

// Coverage4 and assertions4 to be implemented here4.

/*
always @(negedge sig_pclk4)
begin

// Read and write never true4 at the same time
assertReadOrWrite4: assert property (
                   disable iff(!has_checks4) 
                   ($onehot(sig_grant4) |-> !(sig_read4 && sig_write4)))
                   else
                     $error("ERR_READ_OR_WRITE4\n Read and Write true4 at \
                             the same time");

end
*/

endinterface : spi_if4

