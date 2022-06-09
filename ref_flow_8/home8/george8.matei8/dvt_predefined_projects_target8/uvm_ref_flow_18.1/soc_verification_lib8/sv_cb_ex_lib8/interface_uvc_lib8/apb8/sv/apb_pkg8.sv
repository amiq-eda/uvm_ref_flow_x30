/*-------------------------------------------------------------------------
File8 name   : apb_pkg8.sv
Title8       : Package8 for APB8 UVC8
Project8     :
Created8     :
Description8 : 
Notes8       :  
----------------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------

  
`ifndef APB_PKG_SV8
`define APB_PKG_SV8

package apb_pkg8;

// Import8 the UVM class library  and UVM automation8 macros8
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "apb_config8.sv"
`include "apb_types8.sv"
`include "apb_transfer8.sv"
`include "apb_monitor8.sv"
`include "apb_collector8.sv"

`include "apb_master_driver8.sv"
`include "apb_master_sequencer8.sv"
`include "apb_master_agent8.sv"

`include "apb_slave_driver8.sv"
`include "apb_slave_sequencer8.sv"
`include "apb_slave_agent8.sv"

`include "apb_master_seq_lib8.sv"
`include "apb_slave_seq_lib8.sv"

`include "apb_env8.sv"

`include "reg_to_apb_adapter8.sv"

endpackage : apb_pkg8
`endif  // APB_PKG_SV8
