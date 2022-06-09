/*-------------------------------------------------------------------------
File23 name   : uart_ctrl_pkg23.svh
Title23       : Module23 UVC23 Files23
Project23     : UART23 Block Level23
Created23     :
Description23 : 
Notes23       : 
----------------------------------------------------------------------*/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------


`ifndef UART_CRTL_PKG_SV23
`define UART_CRTL_PKG_SV23

package uart_ctrl_pkg23;

import uvm_pkg::*;
`include "uvm_macros.svh"

import apb_pkg23::*;
import uart_pkg23::*;

`include "uart_ctrl_config23.sv"
`include "uart_ctrl_reg_model23.sv"
//`include "reg_to_apb_adapter23.sv"
`include "uart_ctrl_scoreboard23.sv"
`include "coverage23/uart_ctrl_cover23.sv"
`include "uart_ctrl_monitor23.sv"
`include "uart_ctrl_reg_sequencer23.sv"
`include "uart_ctrl_virtual_sequencer23.sv"
`include "uart_ctrl_env23.sv"

endpackage : uart_ctrl_pkg23

`endif //UART_CTRL_PKG_SV23
