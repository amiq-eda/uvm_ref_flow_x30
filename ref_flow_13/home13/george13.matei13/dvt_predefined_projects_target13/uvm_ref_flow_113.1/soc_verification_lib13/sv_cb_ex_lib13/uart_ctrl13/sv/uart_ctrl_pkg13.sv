/*-------------------------------------------------------------------------
File13 name   : uart_ctrl_pkg13.svh
Title13       : Module13 UVC13 Files13
Project13     : UART13 Block Level13
Created13     :
Description13 : 
Notes13       : 
----------------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------


`ifndef UART_CRTL_PKG_SV13
`define UART_CRTL_PKG_SV13

package uart_ctrl_pkg13;

import uvm_pkg::*;
`include "uvm_macros.svh"

import apb_pkg13::*;
import uart_pkg13::*;

`include "uart_ctrl_config13.sv"
`include "uart_ctrl_reg_model13.sv"
//`include "reg_to_apb_adapter13.sv"
`include "uart_ctrl_scoreboard13.sv"
`include "coverage13/uart_ctrl_cover13.sv"
`include "uart_ctrl_monitor13.sv"
`include "uart_ctrl_reg_sequencer13.sv"
`include "uart_ctrl_virtual_sequencer13.sv"
`include "uart_ctrl_env13.sv"

endpackage : uart_ctrl_pkg13

`endif //UART_CTRL_PKG_SV13
