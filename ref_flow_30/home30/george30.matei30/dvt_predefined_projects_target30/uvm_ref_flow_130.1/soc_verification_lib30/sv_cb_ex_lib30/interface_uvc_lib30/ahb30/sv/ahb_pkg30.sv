// IVB30 checksum30: 720351203
/*-----------------------------------------------------------------
File30 name     : ahb_pkg30.sv
Created30       : Wed30 May30 19 15:42:21 2010
Description30   : This30 file imports30 all the files of the OVC30.
Notes30         :
-----------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


`ifndef AHB_PKG_SV30
`define AHB_PKG_SV30

package ahb_pkg30;

// UVM class library compiled30 in a package
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "ahb_defines30.sv"
`include "ahb_transfer30.sv"

`include "ahb_master_monitor30.sv"
`include "ahb_master_sequencer30.sv"
`include "ahb_master_driver30.sv"
`include "ahb_master_agent30.sv"
// Can30 include universally30 reusable30 master30 sequences here30.

`include "ahb_slave_monitor30.sv"
`include "ahb_slave_sequencer30.sv"
`include "ahb_slave_driver30.sv"
`include "ahb_slave_agent30.sv"
// Can30 include universally30 reusable30 slave30 sequences here30.

`include "ahb_env30.sv"
`include "reg_to_ahb_adapter30.sv"

endpackage : ahb_pkg30

`endif // AHB_PKG_SV30
