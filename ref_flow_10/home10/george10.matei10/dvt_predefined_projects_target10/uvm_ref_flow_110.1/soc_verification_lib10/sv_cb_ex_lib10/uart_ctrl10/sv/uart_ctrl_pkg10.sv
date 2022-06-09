/*-------------------------------------------------------------------------
File10 name   : uart_ctrl_pkg10.svh
Title10       : Module10 UVC10 Files10
Project10     : UART10 Block Level10
Created10     :
Description10 : 
Notes10       : 
----------------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------


`ifndef UART_CRTL_PKG_SV10
`define UART_CRTL_PKG_SV10

package uart_ctrl_pkg10;

import uvm_pkg::*;
`include "uvm_macros.svh"

import apb_pkg10::*;
import uart_pkg10::*;

`include "uart_ctrl_config10.sv"
`include "uart_ctrl_reg_model10.sv"
//`include "reg_to_apb_adapter10.sv"
`include "uart_ctrl_scoreboard10.sv"
`include "coverage10/uart_ctrl_cover10.sv"
`include "uart_ctrl_monitor10.sv"
`include "uart_ctrl_reg_sequencer10.sv"
`include "uart_ctrl_virtual_sequencer10.sv"
`include "uart_ctrl_env10.sv"

endpackage : uart_ctrl_pkg10

`endif //UART_CTRL_PKG_SV10
