/*-------------------------------------------------------------------------
File5 name   : uart_ctrl_pkg5.svh
Title5       : Module5 UVC5 Files5
Project5     : UART5 Block Level5
Created5     :
Description5 : 
Notes5       : 
----------------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------


`ifndef UART_CRTL_PKG_SV5
`define UART_CRTL_PKG_SV5

package uart_ctrl_pkg5;

import uvm_pkg::*;
`include "uvm_macros.svh"

import apb_pkg5::*;
import uart_pkg5::*;

`include "uart_ctrl_config5.sv"
`include "uart_ctrl_reg_model5.sv"
//`include "reg_to_apb_adapter5.sv"
`include "uart_ctrl_scoreboard5.sv"
`include "coverage5/uart_ctrl_cover5.sv"
`include "uart_ctrl_monitor5.sv"
`include "uart_ctrl_reg_sequencer5.sv"
`include "uart_ctrl_virtual_sequencer5.sv"
`include "uart_ctrl_env5.sv"

endpackage : uart_ctrl_pkg5

`endif //UART_CTRL_PKG_SV5
