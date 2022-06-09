/*-------------------------------------------------------------------------
File12 name   : uart_ctrl_pkg12.svh
Title12       : Module12 UVC12 Files12
Project12     : UART12 Block Level12
Created12     :
Description12 : 
Notes12       : 
----------------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------


`ifndef UART_CRTL_PKG_SV12
`define UART_CRTL_PKG_SV12

package uart_ctrl_pkg12;

import uvm_pkg::*;
`include "uvm_macros.svh"

import apb_pkg12::*;
import uart_pkg12::*;

`include "uart_ctrl_config12.sv"
`include "uart_ctrl_reg_model12.sv"
//`include "reg_to_apb_adapter12.sv"
`include "uart_ctrl_scoreboard12.sv"
`include "coverage12/uart_ctrl_cover12.sv"
`include "uart_ctrl_monitor12.sv"
`include "uart_ctrl_reg_sequencer12.sv"
`include "uart_ctrl_virtual_sequencer12.sv"
`include "uart_ctrl_env12.sv"

endpackage : uart_ctrl_pkg12

`endif //UART_CTRL_PKG_SV12
