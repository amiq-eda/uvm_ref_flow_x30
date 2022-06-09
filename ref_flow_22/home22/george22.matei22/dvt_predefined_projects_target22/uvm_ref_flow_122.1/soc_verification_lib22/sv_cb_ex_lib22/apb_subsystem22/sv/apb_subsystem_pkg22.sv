/*-------------------------------------------------------------------------
File22 name   : apb_subsystem_pkg22.sv
Title22       : Module22 UVC22 Files22
Project22     : APB22 Subsystem22 Level22
Created22     :
Description22 : 
Notes22       : 
----------------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_PKG_SV22
`define APB_SUBSYSTEM_PKG_SV22

package apb_subsystem_pkg22;

import uvm_pkg::*;
`include "uvm_macros.svh"

import ahb_pkg22::*;
import apb_pkg22::*;
import uart_pkg22::*;
import spi_pkg22::*;
import gpio_pkg22::*;
import uart_ctrl_pkg22::*;

`include "apb_subsystem_config22.sv"
//`include "reg_to_ahb_adapter22.sv"
`include "apb_subsystem_scoreboard22.sv"
`include "apb_subsystem_monitor22.sv"
`include "apb_subsystem_env22.sv"

endpackage : apb_subsystem_pkg22

`endif //APB_SUBSYSTEM_PKG_SV22
