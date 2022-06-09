/*-------------------------------------------------------------------------
File4 name   : uart_ctrl_pkg4.svh
Title4       : Module4 UVC4 Files4
Project4     : UART4 Block Level4
Created4     :
Description4 : 
Notes4       : 
----------------------------------------------------------------------*/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------


`ifndef UART_CRTL_PKG_SV4
`define UART_CRTL_PKG_SV4

package uart_ctrl_pkg4;

import uvm_pkg::*;
`include "uvm_macros.svh"

import apb_pkg4::*;
import uart_pkg4::*;

`include "uart_ctrl_config4.sv"
`include "uart_ctrl_reg_model4.sv"
//`include "reg_to_apb_adapter4.sv"
`include "uart_ctrl_scoreboard4.sv"
`include "coverage4/uart_ctrl_cover4.sv"
`include "uart_ctrl_monitor4.sv"
`include "uart_ctrl_reg_sequencer4.sv"
`include "uart_ctrl_virtual_sequencer4.sv"
`include "uart_ctrl_env4.sv"

endpackage : uart_ctrl_pkg4

`endif //UART_CTRL_PKG_SV4
