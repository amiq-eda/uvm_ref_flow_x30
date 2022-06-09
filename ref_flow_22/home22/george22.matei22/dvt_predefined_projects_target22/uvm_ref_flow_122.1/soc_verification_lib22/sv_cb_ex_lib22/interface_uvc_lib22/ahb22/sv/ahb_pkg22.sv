// IVB22 checksum22: 720351203
/*-----------------------------------------------------------------
File22 name     : ahb_pkg22.sv
Created22       : Wed22 May22 19 15:42:21 2010
Description22   : This22 file imports22 all the files of the OVC22.
Notes22         :
-----------------------------------------------------------------*/
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


`ifndef AHB_PKG_SV22
`define AHB_PKG_SV22

package ahb_pkg22;

// UVM class library compiled22 in a package
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "ahb_defines22.sv"
`include "ahb_transfer22.sv"

`include "ahb_master_monitor22.sv"
`include "ahb_master_sequencer22.sv"
`include "ahb_master_driver22.sv"
`include "ahb_master_agent22.sv"
// Can22 include universally22 reusable22 master22 sequences here22.

`include "ahb_slave_monitor22.sv"
`include "ahb_slave_sequencer22.sv"
`include "ahb_slave_driver22.sv"
`include "ahb_slave_agent22.sv"
// Can22 include universally22 reusable22 slave22 sequences here22.

`include "ahb_env22.sv"
`include "reg_to_ahb_adapter22.sv"

endpackage : ahb_pkg22

`endif // AHB_PKG_SV22
