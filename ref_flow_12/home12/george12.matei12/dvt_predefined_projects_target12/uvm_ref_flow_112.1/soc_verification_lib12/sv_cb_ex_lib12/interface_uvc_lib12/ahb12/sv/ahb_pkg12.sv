// IVB12 checksum12: 720351203
/*-----------------------------------------------------------------
File12 name     : ahb_pkg12.sv
Created12       : Wed12 May12 19 15:42:21 2010
Description12   : This12 file imports12 all the files of the OVC12.
Notes12         :
-----------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------


`ifndef AHB_PKG_SV12
`define AHB_PKG_SV12

package ahb_pkg12;

// UVM class library compiled12 in a package
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "ahb_defines12.sv"
`include "ahb_transfer12.sv"

`include "ahb_master_monitor12.sv"
`include "ahb_master_sequencer12.sv"
`include "ahb_master_driver12.sv"
`include "ahb_master_agent12.sv"
// Can12 include universally12 reusable12 master12 sequences here12.

`include "ahb_slave_monitor12.sv"
`include "ahb_slave_sequencer12.sv"
`include "ahb_slave_driver12.sv"
`include "ahb_slave_agent12.sv"
// Can12 include universally12 reusable12 slave12 sequences here12.

`include "ahb_env12.sv"
`include "reg_to_ahb_adapter12.sv"

endpackage : ahb_pkg12

`endif // AHB_PKG_SV12
