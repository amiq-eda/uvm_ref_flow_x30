// IVB3 checksum3: 720351203
/*-----------------------------------------------------------------
File3 name     : ahb_pkg3.sv
Created3       : Wed3 May3 19 15:42:21 2010
Description3   : This3 file imports3 all the files of the OVC3.
Notes3         :
-----------------------------------------------------------------*/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------


`ifndef AHB_PKG_SV3
`define AHB_PKG_SV3

package ahb_pkg3;

// UVM class library compiled3 in a package
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "ahb_defines3.sv"
`include "ahb_transfer3.sv"

`include "ahb_master_monitor3.sv"
`include "ahb_master_sequencer3.sv"
`include "ahb_master_driver3.sv"
`include "ahb_master_agent3.sv"
// Can3 include universally3 reusable3 master3 sequences here3.

`include "ahb_slave_monitor3.sv"
`include "ahb_slave_sequencer3.sv"
`include "ahb_slave_driver3.sv"
`include "ahb_slave_agent3.sv"
// Can3 include universally3 reusable3 slave3 sequences here3.

`include "ahb_env3.sv"
`include "reg_to_ahb_adapter3.sv"

endpackage : ahb_pkg3

`endif // AHB_PKG_SV3
