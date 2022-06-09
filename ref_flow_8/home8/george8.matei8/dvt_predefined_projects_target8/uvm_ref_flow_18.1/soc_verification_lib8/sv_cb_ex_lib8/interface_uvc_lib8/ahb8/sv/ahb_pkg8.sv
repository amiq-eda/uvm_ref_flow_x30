// IVB8 checksum8: 720351203
/*-----------------------------------------------------------------
File8 name     : ahb_pkg8.sv
Created8       : Wed8 May8 19 15:42:21 2010
Description8   : This8 file imports8 all the files of the OVC8.
Notes8         :
-----------------------------------------------------------------*/
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


`ifndef AHB_PKG_SV8
`define AHB_PKG_SV8

package ahb_pkg8;

// UVM class library compiled8 in a package
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "ahb_defines8.sv"
`include "ahb_transfer8.sv"

`include "ahb_master_monitor8.sv"
`include "ahb_master_sequencer8.sv"
`include "ahb_master_driver8.sv"
`include "ahb_master_agent8.sv"
// Can8 include universally8 reusable8 master8 sequences here8.

`include "ahb_slave_monitor8.sv"
`include "ahb_slave_sequencer8.sv"
`include "ahb_slave_driver8.sv"
`include "ahb_slave_agent8.sv"
// Can8 include universally8 reusable8 slave8 sequences here8.

`include "ahb_env8.sv"
`include "reg_to_ahb_adapter8.sv"

endpackage : ahb_pkg8

`endif // AHB_PKG_SV8
