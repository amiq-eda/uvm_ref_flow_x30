// IVB10 checksum10: 720351203
/*-----------------------------------------------------------------
File10 name     : ahb_pkg10.sv
Created10       : Wed10 May10 19 15:42:21 2010
Description10   : This10 file imports10 all the files of the OVC10.
Notes10         :
-----------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------


`ifndef AHB_PKG_SV10
`define AHB_PKG_SV10

package ahb_pkg10;

// UVM class library compiled10 in a package
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "ahb_defines10.sv"
`include "ahb_transfer10.sv"

`include "ahb_master_monitor10.sv"
`include "ahb_master_sequencer10.sv"
`include "ahb_master_driver10.sv"
`include "ahb_master_agent10.sv"
// Can10 include universally10 reusable10 master10 sequences here10.

`include "ahb_slave_monitor10.sv"
`include "ahb_slave_sequencer10.sv"
`include "ahb_slave_driver10.sv"
`include "ahb_slave_agent10.sv"
// Can10 include universally10 reusable10 slave10 sequences here10.

`include "ahb_env10.sv"
`include "reg_to_ahb_adapter10.sv"

endpackage : ahb_pkg10

`endif // AHB_PKG_SV10
