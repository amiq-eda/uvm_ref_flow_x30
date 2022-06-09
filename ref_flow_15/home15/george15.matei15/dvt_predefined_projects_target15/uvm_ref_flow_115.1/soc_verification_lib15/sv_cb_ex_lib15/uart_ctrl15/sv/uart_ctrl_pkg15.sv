/*-------------------------------------------------------------------------
File15 name   : uart_ctrl_pkg15.svh
Title15       : Module15 UVC15 Files15
Project15     : UART15 Block Level15
Created15     :
Description15 : 
Notes15       : 
----------------------------------------------------------------------*/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------


`ifndef UART_CRTL_PKG_SV15
`define UART_CRTL_PKG_SV15

package uart_ctrl_pkg15;

import uvm_pkg::*;
`include "uvm_macros.svh"

import apb_pkg15::*;
import uart_pkg15::*;

`include "uart_ctrl_config15.sv"
`include "uart_ctrl_reg_model15.sv"
//`include "reg_to_apb_adapter15.sv"
`include "uart_ctrl_scoreboard15.sv"
`include "coverage15/uart_ctrl_cover15.sv"
`include "uart_ctrl_monitor15.sv"
`include "uart_ctrl_reg_sequencer15.sv"
`include "uart_ctrl_virtual_sequencer15.sv"
`include "uart_ctrl_env15.sv"

endpackage : uart_ctrl_pkg15

`endif //UART_CTRL_PKG_SV15
