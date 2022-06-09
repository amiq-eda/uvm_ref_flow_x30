/*-------------------------------------------------------------------------
File13 name   : apb_pkg13.sv
Title13       : Package13 for APB13 UVC13
Project13     :
Created13     :
Description13 : 
Notes13       :  
----------------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------

  
`ifndef APB_PKG_SV13
`define APB_PKG_SV13

package apb_pkg13;

// Import13 the UVM class library  and UVM automation13 macros13
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "apb_config13.sv"
`include "apb_types13.sv"
`include "apb_transfer13.sv"
`include "apb_monitor13.sv"
`include "apb_collector13.sv"

`include "apb_master_driver13.sv"
`include "apb_master_sequencer13.sv"
`include "apb_master_agent13.sv"

`include "apb_slave_driver13.sv"
`include "apb_slave_sequencer13.sv"
`include "apb_slave_agent13.sv"

`include "apb_master_seq_lib13.sv"
`include "apb_slave_seq_lib13.sv"

`include "apb_env13.sv"

`include "reg_to_apb_adapter13.sv"

endpackage : apb_pkg13
`endif  // APB_PKG_SV13
