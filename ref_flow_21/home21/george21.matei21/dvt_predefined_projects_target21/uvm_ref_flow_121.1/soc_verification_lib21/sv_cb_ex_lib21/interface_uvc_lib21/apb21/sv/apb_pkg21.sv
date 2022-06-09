/*-------------------------------------------------------------------------
File21 name   : apb_pkg21.sv
Title21       : Package21 for APB21 UVC21
Project21     :
Created21     :
Description21 : 
Notes21       :  
----------------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------

  
`ifndef APB_PKG_SV21
`define APB_PKG_SV21

package apb_pkg21;

// Import21 the UVM class library  and UVM automation21 macros21
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "apb_config21.sv"
`include "apb_types21.sv"
`include "apb_transfer21.sv"
`include "apb_monitor21.sv"
`include "apb_collector21.sv"

`include "apb_master_driver21.sv"
`include "apb_master_sequencer21.sv"
`include "apb_master_agent21.sv"

`include "apb_slave_driver21.sv"
`include "apb_slave_sequencer21.sv"
`include "apb_slave_agent21.sv"

`include "apb_master_seq_lib21.sv"
`include "apb_slave_seq_lib21.sv"

`include "apb_env21.sv"

`include "reg_to_apb_adapter21.sv"

endpackage : apb_pkg21
`endif  // APB_PKG_SV21
