/*-------------------------------------------------------------------------
File10 name   : apb_subsystem_pkg10.sv
Title10       : Module10 UVC10 Files10
Project10     : APB10 Subsystem10 Level10
Created10     :
Description10 : 
Notes10       : 
----------------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_PKG_SV10
`define APB_SUBSYSTEM_PKG_SV10

package apb_subsystem_pkg10;

import uvm_pkg::*;
`include "uvm_macros.svh"

import ahb_pkg10::*;
import apb_pkg10::*;
import uart_pkg10::*;
import spi_pkg10::*;
import gpio_pkg10::*;
import uart_ctrl_pkg10::*;

`include "apb_subsystem_config10.sv"
//`include "reg_to_ahb_adapter10.sv"
`include "apb_subsystem_scoreboard10.sv"
`include "apb_subsystem_monitor10.sv"
`include "apb_subsystem_env10.sv"

endpackage : apb_subsystem_pkg10

`endif //APB_SUBSYSTEM_PKG_SV10
