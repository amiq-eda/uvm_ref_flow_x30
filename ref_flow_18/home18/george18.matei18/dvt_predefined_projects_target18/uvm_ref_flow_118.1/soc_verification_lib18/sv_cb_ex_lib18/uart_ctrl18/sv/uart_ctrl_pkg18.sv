/*-------------------------------------------------------------------------
File18 name   : uart_ctrl_pkg18.svh
Title18       : Module18 UVC18 Files18
Project18     : UART18 Block Level18
Created18     :
Description18 : 
Notes18       : 
----------------------------------------------------------------------*/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------


`ifndef UART_CRTL_PKG_SV18
`define UART_CRTL_PKG_SV18

package uart_ctrl_pkg18;

import uvm_pkg::*;
`include "uvm_macros.svh"

import apb_pkg18::*;
import uart_pkg18::*;

`include "uart_ctrl_config18.sv"
`include "uart_ctrl_reg_model18.sv"
//`include "reg_to_apb_adapter18.sv"
`include "uart_ctrl_scoreboard18.sv"
`include "coverage18/uart_ctrl_cover18.sv"
`include "uart_ctrl_monitor18.sv"
`include "uart_ctrl_reg_sequencer18.sv"
`include "uart_ctrl_virtual_sequencer18.sv"
`include "uart_ctrl_env18.sv"

endpackage : uart_ctrl_pkg18

`endif //UART_CTRL_PKG_SV18
