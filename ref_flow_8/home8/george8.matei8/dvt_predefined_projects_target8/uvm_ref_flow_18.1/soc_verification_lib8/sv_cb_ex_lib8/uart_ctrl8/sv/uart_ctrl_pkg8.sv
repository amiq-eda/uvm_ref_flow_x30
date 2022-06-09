/*-------------------------------------------------------------------------
File8 name   : uart_ctrl_pkg8.svh
Title8       : Module8 UVC8 Files8
Project8     : UART8 Block Level8
Created8     :
Description8 : 
Notes8       : 
----------------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------


`ifndef UART_CRTL_PKG_SV8
`define UART_CRTL_PKG_SV8

package uart_ctrl_pkg8;

import uvm_pkg::*;
`include "uvm_macros.svh"

import apb_pkg8::*;
import uart_pkg8::*;

`include "uart_ctrl_config8.sv"
`include "uart_ctrl_reg_model8.sv"
//`include "reg_to_apb_adapter8.sv"
`include "uart_ctrl_scoreboard8.sv"
`include "coverage8/uart_ctrl_cover8.sv"
`include "uart_ctrl_monitor8.sv"
`include "uart_ctrl_reg_sequencer8.sv"
`include "uart_ctrl_virtual_sequencer8.sv"
`include "uart_ctrl_env8.sv"

endpackage : uart_ctrl_pkg8

`endif //UART_CTRL_PKG_SV8
