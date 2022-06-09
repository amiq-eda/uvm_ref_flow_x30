// IVB2 checksum2: 720351203
/*-----------------------------------------------------------------
File2 name     : ahb_pkg2.sv
Created2       : Wed2 May2 19 15:42:21 2010
Description2   : This2 file imports2 all the files of the OVC2.
Notes2         :
-----------------------------------------------------------------*/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------


`ifndef AHB_PKG_SV2
`define AHB_PKG_SV2

package ahb_pkg2;

// UVM class library compiled2 in a package
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "ahb_defines2.sv"
`include "ahb_transfer2.sv"

`include "ahb_master_monitor2.sv"
`include "ahb_master_sequencer2.sv"
`include "ahb_master_driver2.sv"
`include "ahb_master_agent2.sv"
// Can2 include universally2 reusable2 master2 sequences here2.

`include "ahb_slave_monitor2.sv"
`include "ahb_slave_sequencer2.sv"
`include "ahb_slave_driver2.sv"
`include "ahb_slave_agent2.sv"
// Can2 include universally2 reusable2 slave2 sequences here2.

`include "ahb_env2.sv"
`include "reg_to_ahb_adapter2.sv"

endpackage : ahb_pkg2

`endif // AHB_PKG_SV2
