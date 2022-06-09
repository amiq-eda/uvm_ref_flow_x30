// IVB20 checksum20: 720351203
/*-----------------------------------------------------------------
File20 name     : ahb_pkg20.sv
Created20       : Wed20 May20 19 15:42:21 2010
Description20   : This20 file imports20 all the files of the OVC20.
Notes20         :
-----------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------


`ifndef AHB_PKG_SV20
`define AHB_PKG_SV20

package ahb_pkg20;

// UVM class library compiled20 in a package
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "ahb_defines20.sv"
`include "ahb_transfer20.sv"

`include "ahb_master_monitor20.sv"
`include "ahb_master_sequencer20.sv"
`include "ahb_master_driver20.sv"
`include "ahb_master_agent20.sv"
// Can20 include universally20 reusable20 master20 sequences here20.

`include "ahb_slave_monitor20.sv"
`include "ahb_slave_sequencer20.sv"
`include "ahb_slave_driver20.sv"
`include "ahb_slave_agent20.sv"
// Can20 include universally20 reusable20 slave20 sequences here20.

`include "ahb_env20.sv"
`include "reg_to_ahb_adapter20.sv"

endpackage : ahb_pkg20

`endif // AHB_PKG_SV20
