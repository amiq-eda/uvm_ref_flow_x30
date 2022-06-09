/*-------------------------------------------------------------------------
File16 name   : uart_ctrl_pkg16.svh
Title16       : Module16 UVC16 Files16
Project16     : UART16 Block Level16
Created16     :
Description16 : 
Notes16       : 
----------------------------------------------------------------------*/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------


`ifndef UART_CRTL_PKG_SV16
`define UART_CRTL_PKG_SV16

package uart_ctrl_pkg16;

import uvm_pkg::*;
`include "uvm_macros.svh"

import apb_pkg16::*;
import uart_pkg16::*;

`include "uart_ctrl_config16.sv"
`include "uart_ctrl_reg_model16.sv"
//`include "reg_to_apb_adapter16.sv"
`include "uart_ctrl_scoreboard16.sv"
`include "coverage16/uart_ctrl_cover16.sv"
`include "uart_ctrl_monitor16.sv"
`include "uart_ctrl_reg_sequencer16.sv"
`include "uart_ctrl_virtual_sequencer16.sv"
`include "uart_ctrl_env16.sv"

endpackage : uart_ctrl_pkg16

`endif //UART_CTRL_PKG_SV16
