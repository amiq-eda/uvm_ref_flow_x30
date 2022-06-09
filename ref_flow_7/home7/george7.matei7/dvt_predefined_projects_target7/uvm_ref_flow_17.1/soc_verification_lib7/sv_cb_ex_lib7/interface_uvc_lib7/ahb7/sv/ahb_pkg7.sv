// IVB7 checksum7: 720351203
/*-----------------------------------------------------------------
File7 name     : ahb_pkg7.sv
Created7       : Wed7 May7 19 15:42:21 2010
Description7   : This7 file imports7 all the files of the OVC7.
Notes7         :
-----------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------


`ifndef AHB_PKG_SV7
`define AHB_PKG_SV7

package ahb_pkg7;

// UVM class library compiled7 in a package
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "ahb_defines7.sv"
`include "ahb_transfer7.sv"

`include "ahb_master_monitor7.sv"
`include "ahb_master_sequencer7.sv"
`include "ahb_master_driver7.sv"
`include "ahb_master_agent7.sv"
// Can7 include universally7 reusable7 master7 sequences here7.

`include "ahb_slave_monitor7.sv"
`include "ahb_slave_sequencer7.sv"
`include "ahb_slave_driver7.sv"
`include "ahb_slave_agent7.sv"
// Can7 include universally7 reusable7 slave7 sequences here7.

`include "ahb_env7.sv"
`include "reg_to_ahb_adapter7.sv"

endpackage : ahb_pkg7

`endif // AHB_PKG_SV7
