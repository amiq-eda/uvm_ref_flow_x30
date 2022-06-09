/*-------------------------------------------------------------------------
File29 name   : spi_if29.sv
Title29       : SPI29 SystemVerilog29 UVM UVC29
Project29     : SystemVerilog29 UVM Cluster29 Level29 Verification29
Created29     :
Description29 : 
Notes29       :  
---------------------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------


interface spi_if29();

  // Control29 flags29
  bit                has_checks29 = 1;
  bit                has_coverage = 1;

  // Actual29 Signals29
  // APB29 Slave29 Interface29 - inputs29
  logic              sig_pclk29;
  logic              sig_n_p_reset29;

  // Slave29 SPI29 Interface29 - inputs29
  logic              sig_si29;                //MOSI29, Slave29 input
  logic              sig_sclk_in29;
  logic              sig_n_ss_in29;
  logic              sig_slave_in_clk29;
  // Slave29 SPI29 Interface29 - outputs29
  logic              sig_slave_out_clk29;
  logic              sig_n_so_en29;          //MISO29, Output29 enable
  logic              sig_so29;               //MISO29, Slave29 output


  // Master29 SPI29 Interface29 - inputs29
  logic              sig_mi29;               //MISO29, Master29 input
  logic              sig_ext_clk29;
  // Master29 SPI29 Interface29 - outputs29
  logic              sig_n_ss_en29;
  logic        [3:0] sig_n_ss_out29;
  logic              sig_n_sclk_en29;
  logic              sig_sclk_out29;
  logic              sig_n_mo_en29;          //MOSI29, Output29 enable
  logic              sig_mo29;               //MOSI29, Master29 input

// Coverage29 and assertions29 to be implemented here29.

/*
always @(negedge sig_pclk29)
begin

// Read and write never true29 at the same time
assertReadOrWrite29: assert property (
                   disable iff(!has_checks29) 
                   ($onehot(sig_grant29) |-> !(sig_read29 && sig_write29)))
                   else
                     $error("ERR_READ_OR_WRITE29\n Read and Write true29 at \
                             the same time");

end
*/

endinterface : spi_if29

