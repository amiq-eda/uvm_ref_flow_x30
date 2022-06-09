// IVB18 checksum18: 720351203
/*-----------------------------------------------------------------
File18 name     : ahb_pkg18.sv
Created18       : Wed18 May18 19 15:42:21 2010
Description18   : This18 file imports18 all the files of the OVC18.
Notes18         :
-----------------------------------------------------------------*/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------


`ifndef AHB_PKG_SV18
`define AHB_PKG_SV18

package ahb_pkg18;

// UVM class library compiled18 in a package
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "ahb_defines18.sv"
`include "ahb_transfer18.sv"

`include "ahb_master_monitor18.sv"
`include "ahb_master_sequencer18.sv"
`include "ahb_master_driver18.sv"
`include "ahb_master_agent18.sv"
// Can18 include universally18 reusable18 master18 sequences here18.

`include "ahb_slave_monitor18.sv"
`include "ahb_slave_sequencer18.sv"
`include "ahb_slave_driver18.sv"
`include "ahb_slave_agent18.sv"
// Can18 include universally18 reusable18 slave18 sequences here18.

`include "ahb_env18.sv"
`include "reg_to_ahb_adapter18.sv"

endpackage : ahb_pkg18

`endif // AHB_PKG_SV18
