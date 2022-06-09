// IVB21 checksum21: 720351203
/*-----------------------------------------------------------------
File21 name     : ahb_pkg21.sv
Created21       : Wed21 May21 19 15:42:21 2010
Description21   : This21 file imports21 all the files of the OVC21.
Notes21         :
-----------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------


`ifndef AHB_PKG_SV21
`define AHB_PKG_SV21

package ahb_pkg21;

// UVM class library compiled21 in a package
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "ahb_defines21.sv"
`include "ahb_transfer21.sv"

`include "ahb_master_monitor21.sv"
`include "ahb_master_sequencer21.sv"
`include "ahb_master_driver21.sv"
`include "ahb_master_agent21.sv"
// Can21 include universally21 reusable21 master21 sequences here21.

`include "ahb_slave_monitor21.sv"
`include "ahb_slave_sequencer21.sv"
`include "ahb_slave_driver21.sv"
`include "ahb_slave_agent21.sv"
// Can21 include universally21 reusable21 slave21 sequences here21.

`include "ahb_env21.sv"
`include "reg_to_ahb_adapter21.sv"

endpackage : ahb_pkg21

`endif // AHB_PKG_SV21
