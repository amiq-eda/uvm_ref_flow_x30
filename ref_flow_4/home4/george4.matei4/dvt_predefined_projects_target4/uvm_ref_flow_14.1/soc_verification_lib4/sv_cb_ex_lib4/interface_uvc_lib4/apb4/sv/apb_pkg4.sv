/*-------------------------------------------------------------------------
File4 name   : apb_pkg4.sv
Title4       : Package4 for APB4 UVC4
Project4     :
Created4     :
Description4 : 
Notes4       :  
----------------------------------------------------------------------*/
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

  
`ifndef APB_PKG_SV4
`define APB_PKG_SV4

package apb_pkg4;

// Import4 the UVM class library  and UVM automation4 macros4
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "apb_config4.sv"
`include "apb_types4.sv"
`include "apb_transfer4.sv"
`include "apb_monitor4.sv"
`include "apb_collector4.sv"

`include "apb_master_driver4.sv"
`include "apb_master_sequencer4.sv"
`include "apb_master_agent4.sv"

`include "apb_slave_driver4.sv"
`include "apb_slave_sequencer4.sv"
`include "apb_slave_agent4.sv"

`include "apb_master_seq_lib4.sv"
`include "apb_slave_seq_lib4.sv"

`include "apb_env4.sv"

`include "reg_to_apb_adapter4.sv"

endpackage : apb_pkg4
`endif  // APB_PKG_SV4
