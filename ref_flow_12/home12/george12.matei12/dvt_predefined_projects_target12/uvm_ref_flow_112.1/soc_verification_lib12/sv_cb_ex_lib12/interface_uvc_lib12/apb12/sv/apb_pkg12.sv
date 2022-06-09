/*-------------------------------------------------------------------------
File12 name   : apb_pkg12.sv
Title12       : Package12 for APB12 UVC12
Project12     :
Created12     :
Description12 : 
Notes12       :  
----------------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------

  
`ifndef APB_PKG_SV12
`define APB_PKG_SV12

package apb_pkg12;

// Import12 the UVM class library  and UVM automation12 macros12
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "apb_config12.sv"
`include "apb_types12.sv"
`include "apb_transfer12.sv"
`include "apb_monitor12.sv"
`include "apb_collector12.sv"

`include "apb_master_driver12.sv"
`include "apb_master_sequencer12.sv"
`include "apb_master_agent12.sv"

`include "apb_slave_driver12.sv"
`include "apb_slave_sequencer12.sv"
`include "apb_slave_agent12.sv"

`include "apb_master_seq_lib12.sv"
`include "apb_slave_seq_lib12.sv"

`include "apb_env12.sv"

`include "reg_to_apb_adapter12.sv"

endpackage : apb_pkg12
`endif  // APB_PKG_SV12
