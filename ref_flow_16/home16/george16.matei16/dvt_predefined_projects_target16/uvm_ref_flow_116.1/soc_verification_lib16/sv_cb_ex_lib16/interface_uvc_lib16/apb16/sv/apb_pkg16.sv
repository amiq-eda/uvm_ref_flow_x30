/*-------------------------------------------------------------------------
File16 name   : apb_pkg16.sv
Title16       : Package16 for APB16 UVC16
Project16     :
Created16     :
Description16 : 
Notes16       :  
----------------------------------------------------------------------*/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------

  
`ifndef APB_PKG_SV16
`define APB_PKG_SV16

package apb_pkg16;

// Import16 the UVM class library  and UVM automation16 macros16
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "apb_config16.sv"
`include "apb_types16.sv"
`include "apb_transfer16.sv"
`include "apb_monitor16.sv"
`include "apb_collector16.sv"

`include "apb_master_driver16.sv"
`include "apb_master_sequencer16.sv"
`include "apb_master_agent16.sv"

`include "apb_slave_driver16.sv"
`include "apb_slave_sequencer16.sv"
`include "apb_slave_agent16.sv"

`include "apb_master_seq_lib16.sv"
`include "apb_slave_seq_lib16.sv"

`include "apb_env16.sv"

`include "reg_to_apb_adapter16.sv"

endpackage : apb_pkg16
`endif  // APB_PKG_SV16
