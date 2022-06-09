// IVB4 checksum4: 720351203
/*-----------------------------------------------------------------
File4 name     : ahb_pkg4.sv
Created4       : Wed4 May4 19 15:42:21 2010
Description4   : This4 file imports4 all the files of the OVC4.
Notes4         :
-----------------------------------------------------------------*/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------


`ifndef AHB_PKG_SV4
`define AHB_PKG_SV4

package ahb_pkg4;

// UVM class library compiled4 in a package
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "ahb_defines4.sv"
`include "ahb_transfer4.sv"

`include "ahb_master_monitor4.sv"
`include "ahb_master_sequencer4.sv"
`include "ahb_master_driver4.sv"
`include "ahb_master_agent4.sv"
// Can4 include universally4 reusable4 master4 sequences here4.

`include "ahb_slave_monitor4.sv"
`include "ahb_slave_sequencer4.sv"
`include "ahb_slave_driver4.sv"
`include "ahb_slave_agent4.sv"
// Can4 include universally4 reusable4 slave4 sequences here4.

`include "ahb_env4.sv"
`include "reg_to_ahb_adapter4.sv"

endpackage : ahb_pkg4

`endif // AHB_PKG_SV4
