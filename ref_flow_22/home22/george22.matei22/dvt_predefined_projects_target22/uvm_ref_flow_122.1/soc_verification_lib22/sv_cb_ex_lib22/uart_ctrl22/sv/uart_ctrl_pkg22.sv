/*-------------------------------------------------------------------------
File22 name   : uart_ctrl_pkg22.svh
Title22       : Module22 UVC22 Files22
Project22     : UART22 Block Level22
Created22     :
Description22 : 
Notes22       : 
----------------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------


`ifndef UART_CRTL_PKG_SV22
`define UART_CRTL_PKG_SV22

package uart_ctrl_pkg22;

import uvm_pkg::*;
`include "uvm_macros.svh"

import apb_pkg22::*;
import uart_pkg22::*;

`include "uart_ctrl_config22.sv"
`include "uart_ctrl_reg_model22.sv"
//`include "reg_to_apb_adapter22.sv"
`include "uart_ctrl_scoreboard22.sv"
`include "coverage22/uart_ctrl_cover22.sv"
`include "uart_ctrl_monitor22.sv"
`include "uart_ctrl_reg_sequencer22.sv"
`include "uart_ctrl_virtual_sequencer22.sv"
`include "uart_ctrl_env22.sv"

endpackage : uart_ctrl_pkg22

`endif //UART_CTRL_PKG_SV22
