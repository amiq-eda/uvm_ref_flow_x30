/*-------------------------------------------------------------------------
File7 name   : spi_if7.sv
Title7       : SPI7 SystemVerilog7 UVM UVC7
Project7     : SystemVerilog7 UVM Cluster7 Level7 Verification7
Created7     :
Description7 : 
Notes7       :  
---------------------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------


interface spi_if7();

  // Control7 flags7
  bit                has_checks7 = 1;
  bit                has_coverage = 1;

  // Actual7 Signals7
  // APB7 Slave7 Interface7 - inputs7
  logic              sig_pclk7;
  logic              sig_n_p_reset7;

  // Slave7 SPI7 Interface7 - inputs7
  logic              sig_si7;                //MOSI7, Slave7 input
  logic              sig_sclk_in7;
  logic              sig_n_ss_in7;
  logic              sig_slave_in_clk7;
  // Slave7 SPI7 Interface7 - outputs7
  logic              sig_slave_out_clk7;
  logic              sig_n_so_en7;          //MISO7, Output7 enable
  logic              sig_so7;               //MISO7, Slave7 output


  // Master7 SPI7 Interface7 - inputs7
  logic              sig_mi7;               //MISO7, Master7 input
  logic              sig_ext_clk7;
  // Master7 SPI7 Interface7 - outputs7
  logic              sig_n_ss_en7;
  logic        [3:0] sig_n_ss_out7;
  logic              sig_n_sclk_en7;
  logic              sig_sclk_out7;
  logic              sig_n_mo_en7;          //MOSI7, Output7 enable
  logic              sig_mo7;               //MOSI7, Master7 input

// Coverage7 and assertions7 to be implemented here7.

/*
always @(negedge sig_pclk7)
begin

// Read and write never true7 at the same time
assertReadOrWrite7: assert property (
                   disable iff(!has_checks7) 
                   ($onehot(sig_grant7) |-> !(sig_read7 && sig_write7)))
                   else
                     $error("ERR_READ_OR_WRITE7\n Read and Write true7 at \
                             the same time");

end
*/

endinterface : spi_if7

