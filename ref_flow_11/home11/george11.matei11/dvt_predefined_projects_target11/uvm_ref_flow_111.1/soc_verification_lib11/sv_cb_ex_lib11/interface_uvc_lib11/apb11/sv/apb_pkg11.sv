/*-------------------------------------------------------------------------
File11 name   : apb_pkg11.sv
Title11       : Package11 for APB11 UVC11
Project11     :
Created11     :
Description11 : 
Notes11       :  
----------------------------------------------------------------------*/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------

  
`ifndef APB_PKG_SV11
`define APB_PKG_SV11

package apb_pkg11;

// Import11 the UVM class library  and UVM automation11 macros11
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "apb_config11.sv"
`include "apb_types11.sv"
`include "apb_transfer11.sv"
`include "apb_monitor11.sv"
`include "apb_collector11.sv"

`include "apb_master_driver11.sv"
`include "apb_master_sequencer11.sv"
`include "apb_master_agent11.sv"

`include "apb_slave_driver11.sv"
`include "apb_slave_sequencer11.sv"
`include "apb_slave_agent11.sv"

`include "apb_master_seq_lib11.sv"
`include "apb_slave_seq_lib11.sv"

`include "apb_env11.sv"

`include "reg_to_apb_adapter11.sv"

endpackage : apb_pkg11
`endif  // APB_PKG_SV11
