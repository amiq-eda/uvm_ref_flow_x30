/*-------------------------------------------------------------------------
File6 name   : spi_if6.sv
Title6       : SPI6 SystemVerilog6 UVM UVC6
Project6     : SystemVerilog6 UVM Cluster6 Level6 Verification6
Created6     :
Description6 : 
Notes6       :  
---------------------------------------------------------------------------*/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------


interface spi_if6();

  // Control6 flags6
  bit                has_checks6 = 1;
  bit                has_coverage = 1;

  // Actual6 Signals6
  // APB6 Slave6 Interface6 - inputs6
  logic              sig_pclk6;
  logic              sig_n_p_reset6;

  // Slave6 SPI6 Interface6 - inputs6
  logic              sig_si6;                //MOSI6, Slave6 input
  logic              sig_sclk_in6;
  logic              sig_n_ss_in6;
  logic              sig_slave_in_clk6;
  // Slave6 SPI6 Interface6 - outputs6
  logic              sig_slave_out_clk6;
  logic              sig_n_so_en6;          //MISO6, Output6 enable
  logic              sig_so6;               //MISO6, Slave6 output


  // Master6 SPI6 Interface6 - inputs6
  logic              sig_mi6;               //MISO6, Master6 input
  logic              sig_ext_clk6;
  // Master6 SPI6 Interface6 - outputs6
  logic              sig_n_ss_en6;
  logic        [3:0] sig_n_ss_out6;
  logic              sig_n_sclk_en6;
  logic              sig_sclk_out6;
  logic              sig_n_mo_en6;          //MOSI6, Output6 enable
  logic              sig_mo6;               //MOSI6, Master6 input

// Coverage6 and assertions6 to be implemented here6.

/*
always @(negedge sig_pclk6)
begin

// Read and write never true6 at the same time
assertReadOrWrite6: assert property (
                   disable iff(!has_checks6) 
                   ($onehot(sig_grant6) |-> !(sig_read6 && sig_write6)))
                   else
                     $error("ERR_READ_OR_WRITE6\n Read and Write true6 at \
                             the same time");

end
*/

endinterface : spi_if6

