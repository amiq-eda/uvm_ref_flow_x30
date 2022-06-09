/*-------------------------------------------------------------------------
File18 name   : spi_if18.sv
Title18       : SPI18 SystemVerilog18 UVM UVC18
Project18     : SystemVerilog18 UVM Cluster18 Level18 Verification18
Created18     :
Description18 : 
Notes18       :  
---------------------------------------------------------------------------*/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------


interface spi_if18();

  // Control18 flags18
  bit                has_checks18 = 1;
  bit                has_coverage = 1;

  // Actual18 Signals18
  // APB18 Slave18 Interface18 - inputs18
  logic              sig_pclk18;
  logic              sig_n_p_reset18;

  // Slave18 SPI18 Interface18 - inputs18
  logic              sig_si18;                //MOSI18, Slave18 input
  logic              sig_sclk_in18;
  logic              sig_n_ss_in18;
  logic              sig_slave_in_clk18;
  // Slave18 SPI18 Interface18 - outputs18
  logic              sig_slave_out_clk18;
  logic              sig_n_so_en18;          //MISO18, Output18 enable
  logic              sig_so18;               //MISO18, Slave18 output


  // Master18 SPI18 Interface18 - inputs18
  logic              sig_mi18;               //MISO18, Master18 input
  logic              sig_ext_clk18;
  // Master18 SPI18 Interface18 - outputs18
  logic              sig_n_ss_en18;
  logic        [3:0] sig_n_ss_out18;
  logic              sig_n_sclk_en18;
  logic              sig_sclk_out18;
  logic              sig_n_mo_en18;          //MOSI18, Output18 enable
  logic              sig_mo18;               //MOSI18, Master18 input

// Coverage18 and assertions18 to be implemented here18.

/*
always @(negedge sig_pclk18)
begin

// Read and write never true18 at the same time
assertReadOrWrite18: assert property (
                   disable iff(!has_checks18) 
                   ($onehot(sig_grant18) |-> !(sig_read18 && sig_write18)))
                   else
                     $error("ERR_READ_OR_WRITE18\n Read and Write true18 at \
                             the same time");

end
*/

endinterface : spi_if18

