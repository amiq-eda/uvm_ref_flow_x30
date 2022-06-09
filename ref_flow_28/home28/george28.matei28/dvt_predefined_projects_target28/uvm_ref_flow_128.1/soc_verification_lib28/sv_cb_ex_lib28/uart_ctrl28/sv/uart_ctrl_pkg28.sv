/*-------------------------------------------------------------------------
File28 name   : uart_ctrl_pkg28.svh
Title28       : Module28 UVC28 Files28
Project28     : UART28 Block Level28
Created28     :
Description28 : 
Notes28       : 
----------------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------


`ifndef UART_CRTL_PKG_SV28
`define UART_CRTL_PKG_SV28

package uart_ctrl_pkg28;

import uvm_pkg::*;
`include "uvm_macros.svh"

import apb_pkg28::*;
import uart_pkg28::*;

`include "uart_ctrl_config28.sv"
`include "uart_ctrl_reg_model28.sv"
//`include "reg_to_apb_adapter28.sv"
`include "uart_ctrl_scoreboard28.sv"
`include "coverage28/uart_ctrl_cover28.sv"
`include "uart_ctrl_monitor28.sv"
`include "uart_ctrl_reg_sequencer28.sv"
`include "uart_ctrl_virtual_sequencer28.sv"
`include "uart_ctrl_env28.sv"

endpackage : uart_ctrl_pkg28

`endif //UART_CTRL_PKG_SV28
