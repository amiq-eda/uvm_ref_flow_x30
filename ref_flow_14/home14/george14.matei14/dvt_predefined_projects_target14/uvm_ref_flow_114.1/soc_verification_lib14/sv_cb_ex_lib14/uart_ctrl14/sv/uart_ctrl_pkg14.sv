/*-------------------------------------------------------------------------
File14 name   : uart_ctrl_pkg14.svh
Title14       : Module14 UVC14 Files14
Project14     : UART14 Block Level14
Created14     :
Description14 : 
Notes14       : 
----------------------------------------------------------------------*/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------


`ifndef UART_CRTL_PKG_SV14
`define UART_CRTL_PKG_SV14

package uart_ctrl_pkg14;

import uvm_pkg::*;
`include "uvm_macros.svh"

import apb_pkg14::*;
import uart_pkg14::*;

`include "uart_ctrl_config14.sv"
`include "uart_ctrl_reg_model14.sv"
//`include "reg_to_apb_adapter14.sv"
`include "uart_ctrl_scoreboard14.sv"
`include "coverage14/uart_ctrl_cover14.sv"
`include "uart_ctrl_monitor14.sv"
`include "uart_ctrl_reg_sequencer14.sv"
`include "uart_ctrl_virtual_sequencer14.sv"
`include "uart_ctrl_env14.sv"

endpackage : uart_ctrl_pkg14

`endif //UART_CTRL_PKG_SV14
