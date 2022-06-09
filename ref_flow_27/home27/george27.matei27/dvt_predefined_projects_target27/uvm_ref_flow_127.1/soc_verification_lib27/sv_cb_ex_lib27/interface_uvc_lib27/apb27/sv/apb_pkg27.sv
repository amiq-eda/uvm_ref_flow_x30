/*-------------------------------------------------------------------------
File27 name   : apb_pkg27.sv
Title27       : Package27 for APB27 UVC27
Project27     :
Created27     :
Description27 : 
Notes27       :  
----------------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------

  
`ifndef APB_PKG_SV27
`define APB_PKG_SV27

package apb_pkg27;

// Import27 the UVM class library  and UVM automation27 macros27
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "apb_config27.sv"
`include "apb_types27.sv"
`include "apb_transfer27.sv"
`include "apb_monitor27.sv"
`include "apb_collector27.sv"

`include "apb_master_driver27.sv"
`include "apb_master_sequencer27.sv"
`include "apb_master_agent27.sv"

`include "apb_slave_driver27.sv"
`include "apb_slave_sequencer27.sv"
`include "apb_slave_agent27.sv"

`include "apb_master_seq_lib27.sv"
`include "apb_slave_seq_lib27.sv"

`include "apb_env27.sv"

`include "reg_to_apb_adapter27.sv"

endpackage : apb_pkg27
`endif  // APB_PKG_SV27
