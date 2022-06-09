// IVB26 checksum26: 720351203
/*-----------------------------------------------------------------
File26 name     : ahb_pkg26.sv
Created26       : Wed26 May26 19 15:42:21 2010
Description26   : This26 file imports26 all the files of the OVC26.
Notes26         :
-----------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


`ifndef AHB_PKG_SV26
`define AHB_PKG_SV26

package ahb_pkg26;

// UVM class library compiled26 in a package
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "ahb_defines26.sv"
`include "ahb_transfer26.sv"

`include "ahb_master_monitor26.sv"
`include "ahb_master_sequencer26.sv"
`include "ahb_master_driver26.sv"
`include "ahb_master_agent26.sv"
// Can26 include universally26 reusable26 master26 sequences here26.

`include "ahb_slave_monitor26.sv"
`include "ahb_slave_sequencer26.sv"
`include "ahb_slave_driver26.sv"
`include "ahb_slave_agent26.sv"
// Can26 include universally26 reusable26 slave26 sequences here26.

`include "ahb_env26.sv"
`include "reg_to_ahb_adapter26.sv"

endpackage : ahb_pkg26

`endif // AHB_PKG_SV26
