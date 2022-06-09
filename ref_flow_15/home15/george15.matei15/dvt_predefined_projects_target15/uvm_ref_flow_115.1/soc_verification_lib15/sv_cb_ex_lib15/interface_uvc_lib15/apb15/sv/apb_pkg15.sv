/*-------------------------------------------------------------------------
File15 name   : apb_pkg15.sv
Title15       : Package15 for APB15 UVC15
Project15     :
Created15     :
Description15 : 
Notes15       :  
----------------------------------------------------------------------*/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------

  
`ifndef APB_PKG_SV15
`define APB_PKG_SV15

package apb_pkg15;

// Import15 the UVM class library  and UVM automation15 macros15
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "apb_config15.sv"
`include "apb_types15.sv"
`include "apb_transfer15.sv"
`include "apb_monitor15.sv"
`include "apb_collector15.sv"

`include "apb_master_driver15.sv"
`include "apb_master_sequencer15.sv"
`include "apb_master_agent15.sv"

`include "apb_slave_driver15.sv"
`include "apb_slave_sequencer15.sv"
`include "apb_slave_agent15.sv"

`include "apb_master_seq_lib15.sv"
`include "apb_slave_seq_lib15.sv"

`include "apb_env15.sv"

`include "reg_to_apb_adapter15.sv"

endpackage : apb_pkg15
`endif  // APB_PKG_SV15
