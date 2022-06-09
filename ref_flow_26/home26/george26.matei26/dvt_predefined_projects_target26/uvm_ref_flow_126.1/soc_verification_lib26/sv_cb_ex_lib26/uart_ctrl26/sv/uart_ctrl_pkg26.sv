/*-------------------------------------------------------------------------
File26 name   : uart_ctrl_pkg26.svh
Title26       : Module26 UVC26 Files26
Project26     : UART26 Block Level26
Created26     :
Description26 : 
Notes26       : 
----------------------------------------------------------------------*/
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


`ifndef UART_CRTL_PKG_SV26
`define UART_CRTL_PKG_SV26

package uart_ctrl_pkg26;

import uvm_pkg::*;
`include "uvm_macros.svh"

import apb_pkg26::*;
import uart_pkg26::*;

`include "uart_ctrl_config26.sv"
`include "uart_ctrl_reg_model26.sv"
//`include "reg_to_apb_adapter26.sv"
`include "uart_ctrl_scoreboard26.sv"
`include "coverage26/uart_ctrl_cover26.sv"
`include "uart_ctrl_monitor26.sv"
`include "uart_ctrl_reg_sequencer26.sv"
`include "uart_ctrl_virtual_sequencer26.sv"
`include "uart_ctrl_env26.sv"

endpackage : uart_ctrl_pkg26

`endif //UART_CTRL_PKG_SV26
