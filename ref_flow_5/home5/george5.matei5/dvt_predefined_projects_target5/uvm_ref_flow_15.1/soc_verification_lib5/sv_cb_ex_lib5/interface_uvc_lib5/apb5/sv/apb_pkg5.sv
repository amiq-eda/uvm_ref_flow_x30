/*-------------------------------------------------------------------------
File5 name   : apb_pkg5.sv
Title5       : Package5 for APB5 UVC5
Project5     :
Created5     :
Description5 : 
Notes5       :  
----------------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------

  
`ifndef APB_PKG_SV5
`define APB_PKG_SV5

package apb_pkg5;

// Import5 the UVM class library  and UVM automation5 macros5
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "apb_config5.sv"
`include "apb_types5.sv"
`include "apb_transfer5.sv"
`include "apb_monitor5.sv"
`include "apb_collector5.sv"

`include "apb_master_driver5.sv"
`include "apb_master_sequencer5.sv"
`include "apb_master_agent5.sv"

`include "apb_slave_driver5.sv"
`include "apb_slave_sequencer5.sv"
`include "apb_slave_agent5.sv"

`include "apb_master_seq_lib5.sv"
`include "apb_slave_seq_lib5.sv"

`include "apb_env5.sv"

`include "reg_to_apb_adapter5.sv"

endpackage : apb_pkg5
`endif  // APB_PKG_SV5
