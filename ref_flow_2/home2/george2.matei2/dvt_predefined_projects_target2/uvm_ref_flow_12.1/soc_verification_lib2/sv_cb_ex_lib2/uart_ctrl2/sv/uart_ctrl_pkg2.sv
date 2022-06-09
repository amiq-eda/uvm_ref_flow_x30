/*-------------------------------------------------------------------------
File2 name   : uart_ctrl_pkg2.svh
Title2       : Module2 UVC2 Files2
Project2     : UART2 Block Level2
Created2     :
Description2 : 
Notes2       : 
----------------------------------------------------------------------*/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------


`ifndef UART_CRTL_PKG_SV2
`define UART_CRTL_PKG_SV2

package uart_ctrl_pkg2;

import uvm_pkg::*;
`include "uvm_macros.svh"

import apb_pkg2::*;
import uart_pkg2::*;

`include "uart_ctrl_config2.sv"
`include "uart_ctrl_reg_model2.sv"
//`include "reg_to_apb_adapter2.sv"
`include "uart_ctrl_scoreboard2.sv"
`include "coverage2/uart_ctrl_cover2.sv"
`include "uart_ctrl_monitor2.sv"
`include "uart_ctrl_reg_sequencer2.sv"
`include "uart_ctrl_virtual_sequencer2.sv"
`include "uart_ctrl_env2.sv"

endpackage : uart_ctrl_pkg2

`endif //UART_CTRL_PKG_SV2
