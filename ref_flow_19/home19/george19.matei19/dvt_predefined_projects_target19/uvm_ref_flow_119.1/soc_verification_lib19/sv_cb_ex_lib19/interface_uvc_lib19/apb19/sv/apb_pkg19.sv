/*-------------------------------------------------------------------------
File19 name   : apb_pkg19.sv
Title19       : Package19 for APB19 UVC19
Project19     :
Created19     :
Description19 : 
Notes19       :  
----------------------------------------------------------------------*/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------

  
`ifndef APB_PKG_SV19
`define APB_PKG_SV19

package apb_pkg19;

// Import19 the UVM class library  and UVM automation19 macros19
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "apb_config19.sv"
`include "apb_types19.sv"
`include "apb_transfer19.sv"
`include "apb_monitor19.sv"
`include "apb_collector19.sv"

`include "apb_master_driver19.sv"
`include "apb_master_sequencer19.sv"
`include "apb_master_agent19.sv"

`include "apb_slave_driver19.sv"
`include "apb_slave_sequencer19.sv"
`include "apb_slave_agent19.sv"

`include "apb_master_seq_lib19.sv"
`include "apb_slave_seq_lib19.sv"

`include "apb_env19.sv"

`include "reg_to_apb_adapter19.sv"

endpackage : apb_pkg19
`endif  // APB_PKG_SV19
