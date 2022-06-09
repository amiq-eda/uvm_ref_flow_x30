// IVB16 checksum16: 720351203
/*-----------------------------------------------------------------
File16 name     : ahb_pkg16.sv
Created16       : Wed16 May16 19 15:42:21 2010
Description16   : This16 file imports16 all the files of the OVC16.
Notes16         :
-----------------------------------------------------------------*/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------


`ifndef AHB_PKG_SV16
`define AHB_PKG_SV16

package ahb_pkg16;

// UVM class library compiled16 in a package
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "ahb_defines16.sv"
`include "ahb_transfer16.sv"

`include "ahb_master_monitor16.sv"
`include "ahb_master_sequencer16.sv"
`include "ahb_master_driver16.sv"
`include "ahb_master_agent16.sv"
// Can16 include universally16 reusable16 master16 sequences here16.

`include "ahb_slave_monitor16.sv"
`include "ahb_slave_sequencer16.sv"
`include "ahb_slave_driver16.sv"
`include "ahb_slave_agent16.sv"
// Can16 include universally16 reusable16 slave16 sequences here16.

`include "ahb_env16.sv"
`include "reg_to_ahb_adapter16.sv"

endpackage : ahb_pkg16

`endif // AHB_PKG_SV16
