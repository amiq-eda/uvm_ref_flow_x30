/*-------------------------------------------------------------------------
File22 name   : spi_if22.sv
Title22       : SPI22 SystemVerilog22 UVM UVC22
Project22     : SystemVerilog22 UVM Cluster22 Level22 Verification22
Created22     :
Description22 : 
Notes22       :  
---------------------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------


interface spi_if22();

  // Control22 flags22
  bit                has_checks22 = 1;
  bit                has_coverage = 1;

  // Actual22 Signals22
  // APB22 Slave22 Interface22 - inputs22
  logic              sig_pclk22;
  logic              sig_n_p_reset22;

  // Slave22 SPI22 Interface22 - inputs22
  logic              sig_si22;                //MOSI22, Slave22 input
  logic              sig_sclk_in22;
  logic              sig_n_ss_in22;
  logic              sig_slave_in_clk22;
  // Slave22 SPI22 Interface22 - outputs22
  logic              sig_slave_out_clk22;
  logic              sig_n_so_en22;          //MISO22, Output22 enable
  logic              sig_so22;               //MISO22, Slave22 output


  // Master22 SPI22 Interface22 - inputs22
  logic              sig_mi22;               //MISO22, Master22 input
  logic              sig_ext_clk22;
  // Master22 SPI22 Interface22 - outputs22
  logic              sig_n_ss_en22;
  logic        [3:0] sig_n_ss_out22;
  logic              sig_n_sclk_en22;
  logic              sig_sclk_out22;
  logic              sig_n_mo_en22;          //MOSI22, Output22 enable
  logic              sig_mo22;               //MOSI22, Master22 input

// Coverage22 and assertions22 to be implemented here22.

/*
always @(negedge sig_pclk22)
begin

// Read and write never true22 at the same time
assertReadOrWrite22: assert property (
                   disable iff(!has_checks22) 
                   ($onehot(sig_grant22) |-> !(sig_read22 && sig_write22)))
                   else
                     $error("ERR_READ_OR_WRITE22\n Read and Write true22 at \
                             the same time");

end
*/

endinterface : spi_if22

