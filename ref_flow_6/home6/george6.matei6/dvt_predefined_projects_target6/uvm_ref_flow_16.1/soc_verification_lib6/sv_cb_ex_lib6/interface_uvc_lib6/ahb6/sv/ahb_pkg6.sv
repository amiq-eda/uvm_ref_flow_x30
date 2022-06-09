// IVB6 checksum6: 720351203
/*-----------------------------------------------------------------
File6 name     : ahb_pkg6.sv
Created6       : Wed6 May6 19 15:42:21 2010
Description6   : This6 file imports6 all the files of the OVC6.
Notes6         :
-----------------------------------------------------------------*/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------


`ifndef AHB_PKG_SV6
`define AHB_PKG_SV6

package ahb_pkg6;

// UVM class library compiled6 in a package
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "ahb_defines6.sv"
`include "ahb_transfer6.sv"

`include "ahb_master_monitor6.sv"
`include "ahb_master_sequencer6.sv"
`include "ahb_master_driver6.sv"
`include "ahb_master_agent6.sv"
// Can6 include universally6 reusable6 master6 sequences here6.

`include "ahb_slave_monitor6.sv"
`include "ahb_slave_sequencer6.sv"
`include "ahb_slave_driver6.sv"
`include "ahb_slave_agent6.sv"
// Can6 include universally6 reusable6 slave6 sequences here6.

`include "ahb_env6.sv"
`include "reg_to_ahb_adapter6.sv"

endpackage : ahb_pkg6

`endif // AHB_PKG_SV6
