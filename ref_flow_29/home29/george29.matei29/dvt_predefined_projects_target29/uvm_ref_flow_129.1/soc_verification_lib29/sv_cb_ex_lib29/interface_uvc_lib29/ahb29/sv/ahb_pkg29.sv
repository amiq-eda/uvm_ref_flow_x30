// IVB29 checksum29: 720351203
/*-----------------------------------------------------------------
File29 name     : ahb_pkg29.sv
Created29       : Wed29 May29 19 15:42:21 2010
Description29   : This29 file imports29 all the files of the OVC29.
Notes29         :
-----------------------------------------------------------------*/
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


`ifndef AHB_PKG_SV29
`define AHB_PKG_SV29

package ahb_pkg29;

// UVM class library compiled29 in a package
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "ahb_defines29.sv"
`include "ahb_transfer29.sv"

`include "ahb_master_monitor29.sv"
`include "ahb_master_sequencer29.sv"
`include "ahb_master_driver29.sv"
`include "ahb_master_agent29.sv"
// Can29 include universally29 reusable29 master29 sequences here29.

`include "ahb_slave_monitor29.sv"
`include "ahb_slave_sequencer29.sv"
`include "ahb_slave_driver29.sv"
`include "ahb_slave_agent29.sv"
// Can29 include universally29 reusable29 slave29 sequences here29.

`include "ahb_env29.sv"
`include "reg_to_ahb_adapter29.sv"

endpackage : ahb_pkg29

`endif // AHB_PKG_SV29
