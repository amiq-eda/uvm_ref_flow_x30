/*-------------------------------------------------------------------------
File29 name   : apb_pkg29.sv
Title29       : Package29 for APB29 UVC29
Project29     :
Created29     :
Description29 : 
Notes29       :  
----------------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------

  
`ifndef APB_PKG_SV29
`define APB_PKG_SV29

package apb_pkg29;

// Import29 the UVM class library  and UVM automation29 macros29
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "apb_config29.sv"
`include "apb_types29.sv"
`include "apb_transfer29.sv"
`include "apb_monitor29.sv"
`include "apb_collector29.sv"

`include "apb_master_driver29.sv"
`include "apb_master_sequencer29.sv"
`include "apb_master_agent29.sv"

`include "apb_slave_driver29.sv"
`include "apb_slave_sequencer29.sv"
`include "apb_slave_agent29.sv"

`include "apb_master_seq_lib29.sv"
`include "apb_slave_seq_lib29.sv"

`include "apb_env29.sv"

`include "reg_to_apb_adapter29.sv"

endpackage : apb_pkg29
`endif  // APB_PKG_SV29
