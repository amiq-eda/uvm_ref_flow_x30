/*-------------------------------------------------------------------------
File6 name   : uart_ctrl_pkg6.svh
Title6       : Module6 UVC6 Files6
Project6     : UART6 Block Level6
Created6     :
Description6 : 
Notes6       : 
----------------------------------------------------------------------*/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------


`ifndef UART_CRTL_PKG_SV6
`define UART_CRTL_PKG_SV6

package uart_ctrl_pkg6;

import uvm_pkg::*;
`include "uvm_macros.svh"

import apb_pkg6::*;
import uart_pkg6::*;

`include "uart_ctrl_config6.sv"
`include "uart_ctrl_reg_model6.sv"
//`include "reg_to_apb_adapter6.sv"
`include "uart_ctrl_scoreboard6.sv"
`include "coverage6/uart_ctrl_cover6.sv"
`include "uart_ctrl_monitor6.sv"
`include "uart_ctrl_reg_sequencer6.sv"
`include "uart_ctrl_virtual_sequencer6.sv"
`include "uart_ctrl_env6.sv"

endpackage : uart_ctrl_pkg6

`endif //UART_CTRL_PKG_SV6
