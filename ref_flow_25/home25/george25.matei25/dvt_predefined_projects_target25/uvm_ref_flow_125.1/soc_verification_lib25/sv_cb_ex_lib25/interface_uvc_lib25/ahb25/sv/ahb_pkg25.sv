// IVB25 checksum25: 720351203
/*-----------------------------------------------------------------
File25 name     : ahb_pkg25.sv
Created25       : Wed25 May25 19 15:42:21 2010
Description25   : This25 file imports25 all the files of the OVC25.
Notes25         :
-----------------------------------------------------------------*/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------


`ifndef AHB_PKG_SV25
`define AHB_PKG_SV25

package ahb_pkg25;

// UVM class library compiled25 in a package
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "ahb_defines25.sv"
`include "ahb_transfer25.sv"

`include "ahb_master_monitor25.sv"
`include "ahb_master_sequencer25.sv"
`include "ahb_master_driver25.sv"
`include "ahb_master_agent25.sv"
// Can25 include universally25 reusable25 master25 sequences here25.

`include "ahb_slave_monitor25.sv"
`include "ahb_slave_sequencer25.sv"
`include "ahb_slave_driver25.sv"
`include "ahb_slave_agent25.sv"
// Can25 include universally25 reusable25 slave25 sequences here25.

`include "ahb_env25.sv"
`include "reg_to_ahb_adapter25.sv"

endpackage : ahb_pkg25

`endif // AHB_PKG_SV25
