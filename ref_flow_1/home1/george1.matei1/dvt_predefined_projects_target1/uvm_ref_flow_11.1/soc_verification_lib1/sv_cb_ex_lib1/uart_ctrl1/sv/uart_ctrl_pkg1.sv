/*-------------------------------------------------------------------------
File1 name   : uart_ctrl_pkg1.svh
Title1       : Module1 UVC1 Files1
Project1     : UART1 Block Level1
Created1     :
Description1 : 
Notes1       : 
----------------------------------------------------------------------*/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------


`ifndef UART_CRTL_PKG_SV1
`define UART_CRTL_PKG_SV1

package uart_ctrl_pkg1;

import uvm_pkg::*;
`include "uvm_macros.svh"

import apb_pkg1::*;
import uart_pkg1::*;

`include "uart_ctrl_config1.sv"
`include "uart_ctrl_reg_model1.sv"
//`include "reg_to_apb_adapter1.sv"
`include "uart_ctrl_scoreboard1.sv"
`include "coverage1/uart_ctrl_cover1.sv"
`include "uart_ctrl_monitor1.sv"
`include "uart_ctrl_reg_sequencer1.sv"
`include "uart_ctrl_virtual_sequencer1.sv"
`include "uart_ctrl_env1.sv"

endpackage : uart_ctrl_pkg1

`endif //UART_CTRL_PKG_SV1
