// IVB14 checksum14: 720351203
/*-----------------------------------------------------------------
File14 name     : ahb_pkg14.sv
Created14       : Wed14 May14 19 15:42:21 2010
Description14   : This14 file imports14 all the files of the OVC14.
Notes14         :
-----------------------------------------------------------------*/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------


`ifndef AHB_PKG_SV14
`define AHB_PKG_SV14

package ahb_pkg14;

// UVM class library compiled14 in a package
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "ahb_defines14.sv"
`include "ahb_transfer14.sv"

`include "ahb_master_monitor14.sv"
`include "ahb_master_sequencer14.sv"
`include "ahb_master_driver14.sv"
`include "ahb_master_agent14.sv"
// Can14 include universally14 reusable14 master14 sequences here14.

`include "ahb_slave_monitor14.sv"
`include "ahb_slave_sequencer14.sv"
`include "ahb_slave_driver14.sv"
`include "ahb_slave_agent14.sv"
// Can14 include universally14 reusable14 slave14 sequences here14.

`include "ahb_env14.sv"
`include "reg_to_ahb_adapter14.sv"

endpackage : ahb_pkg14

`endif // AHB_PKG_SV14
