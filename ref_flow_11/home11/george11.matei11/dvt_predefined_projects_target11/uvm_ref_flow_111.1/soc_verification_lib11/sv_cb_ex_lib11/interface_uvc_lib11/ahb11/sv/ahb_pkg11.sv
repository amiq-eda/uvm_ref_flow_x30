// IVB11 checksum11: 720351203
/*-----------------------------------------------------------------
File11 name     : ahb_pkg11.sv
Created11       : Wed11 May11 19 15:42:21 2010
Description11   : This11 file imports11 all the files of the OVC11.
Notes11         :
-----------------------------------------------------------------*/
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


`ifndef AHB_PKG_SV11
`define AHB_PKG_SV11

package ahb_pkg11;

// UVM class library compiled11 in a package
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "ahb_defines11.sv"
`include "ahb_transfer11.sv"

`include "ahb_master_monitor11.sv"
`include "ahb_master_sequencer11.sv"
`include "ahb_master_driver11.sv"
`include "ahb_master_agent11.sv"
// Can11 include universally11 reusable11 master11 sequences here11.

`include "ahb_slave_monitor11.sv"
`include "ahb_slave_sequencer11.sv"
`include "ahb_slave_driver11.sv"
`include "ahb_slave_agent11.sv"
// Can11 include universally11 reusable11 slave11 sequences here11.

`include "ahb_env11.sv"
`include "reg_to_ahb_adapter11.sv"

endpackage : ahb_pkg11

`endif // AHB_PKG_SV11
