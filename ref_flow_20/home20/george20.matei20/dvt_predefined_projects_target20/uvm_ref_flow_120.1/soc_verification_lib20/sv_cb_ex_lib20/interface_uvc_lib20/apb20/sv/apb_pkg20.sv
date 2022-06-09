/*-------------------------------------------------------------------------
File20 name   : apb_pkg20.sv
Title20       : Package20 for APB20 UVC20
Project20     :
Created20     :
Description20 : 
Notes20       :  
----------------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------

  
`ifndef APB_PKG_SV20
`define APB_PKG_SV20

package apb_pkg20;

// Import20 the UVM class library  and UVM automation20 macros20
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "apb_config20.sv"
`include "apb_types20.sv"
`include "apb_transfer20.sv"
`include "apb_monitor20.sv"
`include "apb_collector20.sv"

`include "apb_master_driver20.sv"
`include "apb_master_sequencer20.sv"
`include "apb_master_agent20.sv"

`include "apb_slave_driver20.sv"
`include "apb_slave_sequencer20.sv"
`include "apb_slave_agent20.sv"

`include "apb_master_seq_lib20.sv"
`include "apb_slave_seq_lib20.sv"

`include "apb_env20.sv"

`include "reg_to_apb_adapter20.sv"

endpackage : apb_pkg20
`endif  // APB_PKG_SV20
