// IVB24 checksum24: 720351203
/*-----------------------------------------------------------------
File24 name     : ahb_pkg24.sv
Created24       : Wed24 May24 19 15:42:21 2010
Description24   : This24 file imports24 all the files of the OVC24.
Notes24         :
-----------------------------------------------------------------*/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------


`ifndef AHB_PKG_SV24
`define AHB_PKG_SV24

package ahb_pkg24;

// UVM class library compiled24 in a package
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "ahb_defines24.sv"
`include "ahb_transfer24.sv"

`include "ahb_master_monitor24.sv"
`include "ahb_master_sequencer24.sv"
`include "ahb_master_driver24.sv"
`include "ahb_master_agent24.sv"
// Can24 include universally24 reusable24 master24 sequences here24.

`include "ahb_slave_monitor24.sv"
`include "ahb_slave_sequencer24.sv"
`include "ahb_slave_driver24.sv"
`include "ahb_slave_agent24.sv"
// Can24 include universally24 reusable24 slave24 sequences here24.

`include "ahb_env24.sv"
`include "reg_to_ahb_adapter24.sv"

endpackage : ahb_pkg24

`endif // AHB_PKG_SV24
