/*-------------------------------------------------------------------------
File26 name   : spi_if26.sv
Title26       : SPI26 SystemVerilog26 UVM UVC26
Project26     : SystemVerilog26 UVM Cluster26 Level26 Verification26
Created26     :
Description26 : 
Notes26       :  
---------------------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


interface spi_if26();

  // Control26 flags26
  bit                has_checks26 = 1;
  bit                has_coverage = 1;

  // Actual26 Signals26
  // APB26 Slave26 Interface26 - inputs26
  logic              sig_pclk26;
  logic              sig_n_p_reset26;

  // Slave26 SPI26 Interface26 - inputs26
  logic              sig_si26;                //MOSI26, Slave26 input
  logic              sig_sclk_in26;
  logic              sig_n_ss_in26;
  logic              sig_slave_in_clk26;
  // Slave26 SPI26 Interface26 - outputs26
  logic              sig_slave_out_clk26;
  logic              sig_n_so_en26;          //MISO26, Output26 enable
  logic              sig_so26;               //MISO26, Slave26 output


  // Master26 SPI26 Interface26 - inputs26
  logic              sig_mi26;               //MISO26, Master26 input
  logic              sig_ext_clk26;
  // Master26 SPI26 Interface26 - outputs26
  logic              sig_n_ss_en26;
  logic        [3:0] sig_n_ss_out26;
  logic              sig_n_sclk_en26;
  logic              sig_sclk_out26;
  logic              sig_n_mo_en26;          //MOSI26, Output26 enable
  logic              sig_mo26;               //MOSI26, Master26 input

// Coverage26 and assertions26 to be implemented here26.

/*
always @(negedge sig_pclk26)
begin

// Read and write never true26 at the same time
assertReadOrWrite26: assert property (
                   disable iff(!has_checks26) 
                   ($onehot(sig_grant26) |-> !(sig_read26 && sig_write26)))
                   else
                     $error("ERR_READ_OR_WRITE26\n Read and Write true26 at \
                             the same time");

end
*/

endinterface : spi_if26

