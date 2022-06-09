/*-------------------------------------------------------------------------
File15 name   : spi_if15.sv
Title15       : SPI15 SystemVerilog15 UVM UVC15
Project15     : SystemVerilog15 UVM Cluster15 Level15 Verification15
Created15     :
Description15 : 
Notes15       :  
---------------------------------------------------------------------------*/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------


interface spi_if15();

  // Control15 flags15
  bit                has_checks15 = 1;
  bit                has_coverage = 1;

  // Actual15 Signals15
  // APB15 Slave15 Interface15 - inputs15
  logic              sig_pclk15;
  logic              sig_n_p_reset15;

  // Slave15 SPI15 Interface15 - inputs15
  logic              sig_si15;                //MOSI15, Slave15 input
  logic              sig_sclk_in15;
  logic              sig_n_ss_in15;
  logic              sig_slave_in_clk15;
  // Slave15 SPI15 Interface15 - outputs15
  logic              sig_slave_out_clk15;
  logic              sig_n_so_en15;          //MISO15, Output15 enable
  logic              sig_so15;               //MISO15, Slave15 output


  // Master15 SPI15 Interface15 - inputs15
  logic              sig_mi15;               //MISO15, Master15 input
  logic              sig_ext_clk15;
  // Master15 SPI15 Interface15 - outputs15
  logic              sig_n_ss_en15;
  logic        [3:0] sig_n_ss_out15;
  logic              sig_n_sclk_en15;
  logic              sig_sclk_out15;
  logic              sig_n_mo_en15;          //MOSI15, Output15 enable
  logic              sig_mo15;               //MOSI15, Master15 input

// Coverage15 and assertions15 to be implemented here15.

/*
always @(negedge sig_pclk15)
begin

// Read and write never true15 at the same time
assertReadOrWrite15: assert property (
                   disable iff(!has_checks15) 
                   ($onehot(sig_grant15) |-> !(sig_read15 && sig_write15)))
                   else
                     $error("ERR_READ_OR_WRITE15\n Read and Write true15 at \
                             the same time");

end
*/

endinterface : spi_if15

