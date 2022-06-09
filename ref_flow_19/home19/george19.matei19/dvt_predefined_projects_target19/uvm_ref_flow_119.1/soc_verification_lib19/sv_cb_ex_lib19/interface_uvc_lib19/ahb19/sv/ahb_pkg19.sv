// IVB19 checksum19: 720351203
/*-----------------------------------------------------------------
File19 name     : ahb_pkg19.sv
Created19       : Wed19 May19 19 15:42:21 2010
Description19   : This19 file imports19 all the files of the OVC19.
Notes19         :
-----------------------------------------------------------------*/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------


`ifndef AHB_PKG_SV19
`define AHB_PKG_SV19

package ahb_pkg19;

// UVM class library compiled19 in a package
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "ahb_defines19.sv"
`include "ahb_transfer19.sv"

`include "ahb_master_monitor19.sv"
`include "ahb_master_sequencer19.sv"
`include "ahb_master_driver19.sv"
`include "ahb_master_agent19.sv"
// Can19 include universally19 reusable19 master19 sequences here19.

`include "ahb_slave_monitor19.sv"
`include "ahb_slave_sequencer19.sv"
`include "ahb_slave_driver19.sv"
`include "ahb_slave_agent19.sv"
// Can19 include universally19 reusable19 slave19 sequences here19.

`include "ahb_env19.sv"
`include "reg_to_ahb_adapter19.sv"

endpackage : ahb_pkg19

`endif // AHB_PKG_SV19
