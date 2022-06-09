// IVB28 checksum28: 720351203
/*-----------------------------------------------------------------
File28 name     : ahb_pkg28.sv
Created28       : Wed28 May28 19 15:42:21 2010
Description28   : This28 file imports28 all the files of the OVC28.
Notes28         :
-----------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------


`ifndef AHB_PKG_SV28
`define AHB_PKG_SV28

package ahb_pkg28;

// UVM class library compiled28 in a package
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "ahb_defines28.sv"
`include "ahb_transfer28.sv"

`include "ahb_master_monitor28.sv"
`include "ahb_master_sequencer28.sv"
`include "ahb_master_driver28.sv"
`include "ahb_master_agent28.sv"
// Can28 include universally28 reusable28 master28 sequences here28.

`include "ahb_slave_monitor28.sv"
`include "ahb_slave_sequencer28.sv"
`include "ahb_slave_driver28.sv"
`include "ahb_slave_agent28.sv"
// Can28 include universally28 reusable28 slave28 sequences here28.

`include "ahb_env28.sv"
`include "reg_to_ahb_adapter28.sv"

endpackage : ahb_pkg28

`endif // AHB_PKG_SV28
