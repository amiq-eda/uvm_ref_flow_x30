/*-------------------------------------------------------------------------
File23 name   : spi_if23.sv
Title23       : SPI23 SystemVerilog23 UVM UVC23
Project23     : SystemVerilog23 UVM Cluster23 Level23 Verification23
Created23     :
Description23 : 
Notes23       :  
---------------------------------------------------------------------------*/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------


interface spi_if23();

  // Control23 flags23
  bit                has_checks23 = 1;
  bit                has_coverage = 1;

  // Actual23 Signals23
  // APB23 Slave23 Interface23 - inputs23
  logic              sig_pclk23;
  logic              sig_n_p_reset23;

  // Slave23 SPI23 Interface23 - inputs23
  logic              sig_si23;                //MOSI23, Slave23 input
  logic              sig_sclk_in23;
  logic              sig_n_ss_in23;
  logic              sig_slave_in_clk23;
  // Slave23 SPI23 Interface23 - outputs23
  logic              sig_slave_out_clk23;
  logic              sig_n_so_en23;          //MISO23, Output23 enable
  logic              sig_so23;               //MISO23, Slave23 output


  // Master23 SPI23 Interface23 - inputs23
  logic              sig_mi23;               //MISO23, Master23 input
  logic              sig_ext_clk23;
  // Master23 SPI23 Interface23 - outputs23
  logic              sig_n_ss_en23;
  logic        [3:0] sig_n_ss_out23;
  logic              sig_n_sclk_en23;
  logic              sig_sclk_out23;
  logic              sig_n_mo_en23;          //MOSI23, Output23 enable
  logic              sig_mo23;               //MOSI23, Master23 input

// Coverage23 and assertions23 to be implemented here23.

/*
always @(negedge sig_pclk23)
begin

// Read and write never true23 at the same time
assertReadOrWrite23: assert property (
                   disable iff(!has_checks23) 
                   ($onehot(sig_grant23) |-> !(sig_read23 && sig_write23)))
                   else
                     $error("ERR_READ_OR_WRITE23\n Read and Write true23 at \
                             the same time");

end
*/

endinterface : spi_if23

