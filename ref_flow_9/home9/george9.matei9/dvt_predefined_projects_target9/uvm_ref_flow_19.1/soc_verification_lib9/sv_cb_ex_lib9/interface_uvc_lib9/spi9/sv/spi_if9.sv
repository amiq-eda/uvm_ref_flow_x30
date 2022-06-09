/*-------------------------------------------------------------------------
File9 name   : spi_if9.sv
Title9       : SPI9 SystemVerilog9 UVM UVC9
Project9     : SystemVerilog9 UVM Cluster9 Level9 Verification9
Created9     :
Description9 : 
Notes9       :  
---------------------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------


interface spi_if9();

  // Control9 flags9
  bit                has_checks9 = 1;
  bit                has_coverage = 1;

  // Actual9 Signals9
  // APB9 Slave9 Interface9 - inputs9
  logic              sig_pclk9;
  logic              sig_n_p_reset9;

  // Slave9 SPI9 Interface9 - inputs9
  logic              sig_si9;                //MOSI9, Slave9 input
  logic              sig_sclk_in9;
  logic              sig_n_ss_in9;
  logic              sig_slave_in_clk9;
  // Slave9 SPI9 Interface9 - outputs9
  logic              sig_slave_out_clk9;
  logic              sig_n_so_en9;          //MISO9, Output9 enable
  logic              sig_so9;               //MISO9, Slave9 output


  // Master9 SPI9 Interface9 - inputs9
  logic              sig_mi9;               //MISO9, Master9 input
  logic              sig_ext_clk9;
  // Master9 SPI9 Interface9 - outputs9
  logic              sig_n_ss_en9;
  logic        [3:0] sig_n_ss_out9;
  logic              sig_n_sclk_en9;
  logic              sig_sclk_out9;
  logic              sig_n_mo_en9;          //MOSI9, Output9 enable
  logic              sig_mo9;               //MOSI9, Master9 input

// Coverage9 and assertions9 to be implemented here9.

/*
always @(negedge sig_pclk9)
begin

// Read and write never true9 at the same time
assertReadOrWrite9: assert property (
                   disable iff(!has_checks9) 
                   ($onehot(sig_grant9) |-> !(sig_read9 && sig_write9)))
                   else
                     $error("ERR_READ_OR_WRITE9\n Read and Write true9 at \
                             the same time");

end
*/

endinterface : spi_if9

