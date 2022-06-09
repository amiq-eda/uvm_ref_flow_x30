/*-------------------------------------------------------------------------
File14 name   : apb_pkg14.sv
Title14       : Package14 for APB14 UVC14
Project14     :
Created14     :
Description14 : 
Notes14       :  
----------------------------------------------------------------------*/
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

  
`ifndef APB_PKG_SV14
`define APB_PKG_SV14

package apb_pkg14;

// Import14 the UVM class library  and UVM automation14 macros14
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "apb_config14.sv"
`include "apb_types14.sv"
`include "apb_transfer14.sv"
`include "apb_monitor14.sv"
`include "apb_collector14.sv"

`include "apb_master_driver14.sv"
`include "apb_master_sequencer14.sv"
`include "apb_master_agent14.sv"

`include "apb_slave_driver14.sv"
`include "apb_slave_sequencer14.sv"
`include "apb_slave_agent14.sv"

`include "apb_master_seq_lib14.sv"
`include "apb_slave_seq_lib14.sv"

`include "apb_env14.sv"

`include "reg_to_apb_adapter14.sv"

endpackage : apb_pkg14
`endif  // APB_PKG_SV14
