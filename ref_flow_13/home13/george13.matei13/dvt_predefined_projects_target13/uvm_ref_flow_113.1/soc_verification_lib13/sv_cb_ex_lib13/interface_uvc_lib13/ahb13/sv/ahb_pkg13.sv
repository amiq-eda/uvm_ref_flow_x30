// IVB13 checksum13: 720351203
/*-----------------------------------------------------------------
File13 name     : ahb_pkg13.sv
Created13       : Wed13 May13 19 15:42:21 2010
Description13   : This13 file imports13 all the files of the OVC13.
Notes13         :
-----------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------


`ifndef AHB_PKG_SV13
`define AHB_PKG_SV13

package ahb_pkg13;

// UVM class library compiled13 in a package
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "ahb_defines13.sv"
`include "ahb_transfer13.sv"

`include "ahb_master_monitor13.sv"
`include "ahb_master_sequencer13.sv"
`include "ahb_master_driver13.sv"
`include "ahb_master_agent13.sv"
// Can13 include universally13 reusable13 master13 sequences here13.

`include "ahb_slave_monitor13.sv"
`include "ahb_slave_sequencer13.sv"
`include "ahb_slave_driver13.sv"
`include "ahb_slave_agent13.sv"
// Can13 include universally13 reusable13 slave13 sequences here13.

`include "ahb_env13.sv"
`include "reg_to_ahb_adapter13.sv"

endpackage : ahb_pkg13

`endif // AHB_PKG_SV13
