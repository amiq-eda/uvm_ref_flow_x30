// IVB17 checksum17: 720351203
/*-----------------------------------------------------------------
File17 name     : ahb_pkg17.sv
Created17       : Wed17 May17 19 15:42:21 2010
Description17   : This17 file imports17 all the files of the OVC17.
Notes17         :
-----------------------------------------------------------------*/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------


`ifndef AHB_PKG_SV17
`define AHB_PKG_SV17

package ahb_pkg17;

// UVM class library compiled17 in a package
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "ahb_defines17.sv"
`include "ahb_transfer17.sv"

`include "ahb_master_monitor17.sv"
`include "ahb_master_sequencer17.sv"
`include "ahb_master_driver17.sv"
`include "ahb_master_agent17.sv"
// Can17 include universally17 reusable17 master17 sequences here17.

`include "ahb_slave_monitor17.sv"
`include "ahb_slave_sequencer17.sv"
`include "ahb_slave_driver17.sv"
`include "ahb_slave_agent17.sv"
// Can17 include universally17 reusable17 slave17 sequences here17.

`include "ahb_env17.sv"
`include "reg_to_ahb_adapter17.sv"

endpackage : ahb_pkg17

`endif // AHB_PKG_SV17
