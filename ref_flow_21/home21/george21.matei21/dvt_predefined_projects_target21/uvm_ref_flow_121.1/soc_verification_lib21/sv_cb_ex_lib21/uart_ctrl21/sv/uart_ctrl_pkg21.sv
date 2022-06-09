/*-------------------------------------------------------------------------
File21 name   : uart_ctrl_pkg21.svh
Title21       : Module21 UVC21 Files21
Project21     : UART21 Block Level21
Created21     :
Description21 : 
Notes21       : 
----------------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------


`ifndef UART_CRTL_PKG_SV21
`define UART_CRTL_PKG_SV21

package uart_ctrl_pkg21;

import uvm_pkg::*;
`include "uvm_macros.svh"

import apb_pkg21::*;
import uart_pkg21::*;

`include "uart_ctrl_config21.sv"
`include "uart_ctrl_reg_model21.sv"
//`include "reg_to_apb_adapter21.sv"
`include "uart_ctrl_scoreboard21.sv"
`include "coverage21/uart_ctrl_cover21.sv"
`include "uart_ctrl_monitor21.sv"
`include "uart_ctrl_reg_sequencer21.sv"
`include "uart_ctrl_virtual_sequencer21.sv"
`include "uart_ctrl_env21.sv"

endpackage : uart_ctrl_pkg21

`endif //UART_CTRL_PKG_SV21
