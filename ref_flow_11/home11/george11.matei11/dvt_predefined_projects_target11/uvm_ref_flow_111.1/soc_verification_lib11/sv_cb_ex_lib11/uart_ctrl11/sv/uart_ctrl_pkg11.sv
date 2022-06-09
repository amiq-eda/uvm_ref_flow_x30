/*-------------------------------------------------------------------------
File11 name   : uart_ctrl_pkg11.svh
Title11       : Module11 UVC11 Files11
Project11     : UART11 Block Level11
Created11     :
Description11 : 
Notes11       : 
----------------------------------------------------------------------*/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------


`ifndef UART_CRTL_PKG_SV11
`define UART_CRTL_PKG_SV11

package uart_ctrl_pkg11;

import uvm_pkg::*;
`include "uvm_macros.svh"

import apb_pkg11::*;
import uart_pkg11::*;

`include "uart_ctrl_config11.sv"
`include "uart_ctrl_reg_model11.sv"
//`include "reg_to_apb_adapter11.sv"
`include "uart_ctrl_scoreboard11.sv"
`include "coverage11/uart_ctrl_cover11.sv"
`include "uart_ctrl_monitor11.sv"
`include "uart_ctrl_reg_sequencer11.sv"
`include "uart_ctrl_virtual_sequencer11.sv"
`include "uart_ctrl_env11.sv"

endpackage : uart_ctrl_pkg11

`endif //UART_CTRL_PKG_SV11
