/*-------------------------------------------------------------------------
File22 name   : apb_pkg22.sv
Title22       : Package22 for APB22 UVC22
Project22     :
Created22     :
Description22 : 
Notes22       :  
----------------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------

  
`ifndef APB_PKG_SV22
`define APB_PKG_SV22

package apb_pkg22;

// Import22 the UVM class library  and UVM automation22 macros22
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "apb_config22.sv"
`include "apb_types22.sv"
`include "apb_transfer22.sv"
`include "apb_monitor22.sv"
`include "apb_collector22.sv"

`include "apb_master_driver22.sv"
`include "apb_master_sequencer22.sv"
`include "apb_master_agent22.sv"

`include "apb_slave_driver22.sv"
`include "apb_slave_sequencer22.sv"
`include "apb_slave_agent22.sv"

`include "apb_master_seq_lib22.sv"
`include "apb_slave_seq_lib22.sv"

`include "apb_env22.sv"

`include "reg_to_apb_adapter22.sv"

endpackage : apb_pkg22
`endif  // APB_PKG_SV22
