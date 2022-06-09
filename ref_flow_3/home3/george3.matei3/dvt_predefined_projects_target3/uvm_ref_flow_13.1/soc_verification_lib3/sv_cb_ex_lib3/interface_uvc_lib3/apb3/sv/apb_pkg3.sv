/*-------------------------------------------------------------------------
File3 name   : apb_pkg3.sv
Title3       : Package3 for APB3 UVC3
Project3     :
Created3     :
Description3 : 
Notes3       :  
----------------------------------------------------------------------*/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------

  
`ifndef APB_PKG_SV3
`define APB_PKG_SV3

package apb_pkg3;

// Import3 the UVM class library  and UVM automation3 macros3
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "apb_config3.sv"
`include "apb_types3.sv"
`include "apb_transfer3.sv"
`include "apb_monitor3.sv"
`include "apb_collector3.sv"

`include "apb_master_driver3.sv"
`include "apb_master_sequencer3.sv"
`include "apb_master_agent3.sv"

`include "apb_slave_driver3.sv"
`include "apb_slave_sequencer3.sv"
`include "apb_slave_agent3.sv"

`include "apb_master_seq_lib3.sv"
`include "apb_slave_seq_lib3.sv"

`include "apb_env3.sv"

`include "reg_to_apb_adapter3.sv"

endpackage : apb_pkg3
`endif  // APB_PKG_SV3
