/*-------------------------------------------------------------------------
File25 name   : apb_pkg25.sv
Title25       : Package25 for APB25 UVC25
Project25     :
Created25     :
Description25 : 
Notes25       :  
----------------------------------------------------------------------*/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------

  
`ifndef APB_PKG_SV25
`define APB_PKG_SV25

package apb_pkg25;

// Import25 the UVM class library  and UVM automation25 macros25
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "apb_config25.sv"
`include "apb_types25.sv"
`include "apb_transfer25.sv"
`include "apb_monitor25.sv"
`include "apb_collector25.sv"

`include "apb_master_driver25.sv"
`include "apb_master_sequencer25.sv"
`include "apb_master_agent25.sv"

`include "apb_slave_driver25.sv"
`include "apb_slave_sequencer25.sv"
`include "apb_slave_agent25.sv"

`include "apb_master_seq_lib25.sv"
`include "apb_slave_seq_lib25.sv"

`include "apb_env25.sv"

`include "reg_to_apb_adapter25.sv"

endpackage : apb_pkg25
`endif  // APB_PKG_SV25
