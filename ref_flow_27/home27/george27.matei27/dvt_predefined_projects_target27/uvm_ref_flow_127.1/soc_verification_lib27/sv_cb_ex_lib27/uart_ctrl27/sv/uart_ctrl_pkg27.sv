/*-------------------------------------------------------------------------
File27 name   : uart_ctrl_pkg27.svh
Title27       : Module27 UVC27 Files27
Project27     : UART27 Block Level27
Created27     :
Description27 : 
Notes27       : 
----------------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


`ifndef UART_CRTL_PKG_SV27
`define UART_CRTL_PKG_SV27

package uart_ctrl_pkg27;

import uvm_pkg::*;
`include "uvm_macros.svh"

import apb_pkg27::*;
import uart_pkg27::*;

`include "uart_ctrl_config27.sv"
`include "uart_ctrl_reg_model27.sv"
//`include "reg_to_apb_adapter27.sv"
`include "uart_ctrl_scoreboard27.sv"
`include "coverage27/uart_ctrl_cover27.sv"
`include "uart_ctrl_monitor27.sv"
`include "uart_ctrl_reg_sequencer27.sv"
`include "uart_ctrl_virtual_sequencer27.sv"
`include "uart_ctrl_env27.sv"

endpackage : uart_ctrl_pkg27

`endif //UART_CTRL_PKG_SV27
