// IVB9 checksum9: 720351203
/*-----------------------------------------------------------------
File9 name     : ahb_pkg9.sv
Created9       : Wed9 May9 19 15:42:21 2010
Description9   : This9 file imports9 all the files of the OVC9.
Notes9         :
-----------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------


`ifndef AHB_PKG_SV9
`define AHB_PKG_SV9

package ahb_pkg9;

// UVM class library compiled9 in a package
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "ahb_defines9.sv"
`include "ahb_transfer9.sv"

`include "ahb_master_monitor9.sv"
`include "ahb_master_sequencer9.sv"
`include "ahb_master_driver9.sv"
`include "ahb_master_agent9.sv"
// Can9 include universally9 reusable9 master9 sequences here9.

`include "ahb_slave_monitor9.sv"
`include "ahb_slave_sequencer9.sv"
`include "ahb_slave_driver9.sv"
`include "ahb_slave_agent9.sv"
// Can9 include universally9 reusable9 slave9 sequences here9.

`include "ahb_env9.sv"
`include "reg_to_ahb_adapter9.sv"

endpackage : ahb_pkg9

`endif // AHB_PKG_SV9
