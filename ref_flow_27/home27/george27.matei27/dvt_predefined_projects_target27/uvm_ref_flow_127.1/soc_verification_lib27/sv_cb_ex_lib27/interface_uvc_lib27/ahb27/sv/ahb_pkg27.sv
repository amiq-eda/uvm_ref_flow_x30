// IVB27 checksum27: 720351203
/*-----------------------------------------------------------------
File27 name     : ahb_pkg27.sv
Created27       : Wed27 May27 19 15:42:21 2010
Description27   : This27 file imports27 all the files of the OVC27.
Notes27         :
-----------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


`ifndef AHB_PKG_SV27
`define AHB_PKG_SV27

package ahb_pkg27;

// UVM class library compiled27 in a package
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "ahb_defines27.sv"
`include "ahb_transfer27.sv"

`include "ahb_master_monitor27.sv"
`include "ahb_master_sequencer27.sv"
`include "ahb_master_driver27.sv"
`include "ahb_master_agent27.sv"
// Can27 include universally27 reusable27 master27 sequences here27.

`include "ahb_slave_monitor27.sv"
`include "ahb_slave_sequencer27.sv"
`include "ahb_slave_driver27.sv"
`include "ahb_slave_agent27.sv"
// Can27 include universally27 reusable27 slave27 sequences here27.

`include "ahb_env27.sv"
`include "reg_to_ahb_adapter27.sv"

endpackage : ahb_pkg27

`endif // AHB_PKG_SV27
