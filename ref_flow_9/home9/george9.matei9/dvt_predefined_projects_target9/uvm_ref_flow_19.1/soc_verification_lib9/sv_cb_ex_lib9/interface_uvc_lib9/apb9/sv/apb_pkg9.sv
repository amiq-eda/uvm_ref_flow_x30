/*-------------------------------------------------------------------------
File9 name   : apb_pkg9.sv
Title9       : Package9 for APB9 UVC9
Project9     :
Created9     :
Description9 : 
Notes9       :  
----------------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------

  
`ifndef APB_PKG_SV9
`define APB_PKG_SV9

package apb_pkg9;

// Import9 the UVM class library  and UVM automation9 macros9
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "apb_config9.sv"
`include "apb_types9.sv"
`include "apb_transfer9.sv"
`include "apb_monitor9.sv"
`include "apb_collector9.sv"

`include "apb_master_driver9.sv"
`include "apb_master_sequencer9.sv"
`include "apb_master_agent9.sv"

`include "apb_slave_driver9.sv"
`include "apb_slave_sequencer9.sv"
`include "apb_slave_agent9.sv"

`include "apb_master_seq_lib9.sv"
`include "apb_slave_seq_lib9.sv"

`include "apb_env9.sv"

`include "reg_to_apb_adapter9.sv"

endpackage : apb_pkg9
`endif  // APB_PKG_SV9
