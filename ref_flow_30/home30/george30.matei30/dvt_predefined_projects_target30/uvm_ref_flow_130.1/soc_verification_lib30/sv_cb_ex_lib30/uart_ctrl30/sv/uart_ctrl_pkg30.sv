/*-------------------------------------------------------------------------
File30 name   : uart_ctrl_pkg30.svh
Title30       : Module30 UVC30 Files30
Project30     : UART30 Block Level30
Created30     :
Description30 : 
Notes30       : 
----------------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


`ifndef UART_CRTL_PKG_SV30
`define UART_CRTL_PKG_SV30

package uart_ctrl_pkg30;

import uvm_pkg::*;
`include "uvm_macros.svh"

import apb_pkg30::*;
import uart_pkg30::*;

`include "uart_ctrl_config30.sv"
`include "uart_ctrl_reg_model30.sv"
//`include "reg_to_apb_adapter30.sv"
`include "uart_ctrl_scoreboard30.sv"
`include "coverage30/uart_ctrl_cover30.sv"
`include "uart_ctrl_monitor30.sv"
`include "uart_ctrl_reg_sequencer30.sv"
`include "uart_ctrl_virtual_sequencer30.sv"
`include "uart_ctrl_env30.sv"

endpackage : uart_ctrl_pkg30

`endif //UART_CTRL_PKG_SV30
