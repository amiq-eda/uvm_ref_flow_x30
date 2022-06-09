/*-------------------------------------------------------------------------
File12 name   : spi_if12.sv
Title12       : SPI12 SystemVerilog12 UVM UVC12
Project12     : SystemVerilog12 UVM Cluster12 Level12 Verification12
Created12     :
Description12 : 
Notes12       :  
---------------------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------


interface spi_if12();

  // Control12 flags12
  bit                has_checks12 = 1;
  bit                has_coverage = 1;

  // Actual12 Signals12
  // APB12 Slave12 Interface12 - inputs12
  logic              sig_pclk12;
  logic              sig_n_p_reset12;

  // Slave12 SPI12 Interface12 - inputs12
  logic              sig_si12;                //MOSI12, Slave12 input
  logic              sig_sclk_in12;
  logic              sig_n_ss_in12;
  logic              sig_slave_in_clk12;
  // Slave12 SPI12 Interface12 - outputs12
  logic              sig_slave_out_clk12;
  logic              sig_n_so_en12;          //MISO12, Output12 enable
  logic              sig_so12;               //MISO12, Slave12 output


  // Master12 SPI12 Interface12 - inputs12
  logic              sig_mi12;               //MISO12, Master12 input
  logic              sig_ext_clk12;
  // Master12 SPI12 Interface12 - outputs12
  logic              sig_n_ss_en12;
  logic        [3:0] sig_n_ss_out12;
  logic              sig_n_sclk_en12;
  logic              sig_sclk_out12;
  logic              sig_n_mo_en12;          //MOSI12, Output12 enable
  logic              sig_mo12;               //MOSI12, Master12 input

// Coverage12 and assertions12 to be implemented here12.

/*
always @(negedge sig_pclk12)
begin

// Read and write never true12 at the same time
assertReadOrWrite12: assert property (
                   disable iff(!has_checks12) 
                   ($onehot(sig_grant12) |-> !(sig_read12 && sig_write12)))
                   else
                     $error("ERR_READ_OR_WRITE12\n Read and Write true12 at \
                             the same time");

end
*/

endinterface : spi_if12

