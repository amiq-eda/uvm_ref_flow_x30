// IVB1 checksum1: 720351203
/*-----------------------------------------------------------------
File1 name     : ahb_pkg1.sv
Created1       : Wed1 May1 19 15:42:21 2010
Description1   : This1 file imports1 all the files of the OVC1.
Notes1         :
-----------------------------------------------------------------*/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------


`ifndef AHB_PKG_SV1
`define AHB_PKG_SV1

package ahb_pkg1;

// UVM class library compiled1 in a package
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "ahb_defines1.sv"
`include "ahb_transfer1.sv"

`include "ahb_master_monitor1.sv"
`include "ahb_master_sequencer1.sv"
`include "ahb_master_driver1.sv"
`include "ahb_master_agent1.sv"
// Can1 include universally1 reusable1 master1 sequences here1.

`include "ahb_slave_monitor1.sv"
`include "ahb_slave_sequencer1.sv"
`include "ahb_slave_driver1.sv"
`include "ahb_slave_agent1.sv"
// Can1 include universally1 reusable1 slave1 sequences here1.

`include "ahb_env1.sv"
`include "reg_to_ahb_adapter1.sv"

endpackage : ahb_pkg1

`endif // AHB_PKG_SV1
