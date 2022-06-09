/*-------------------------------------------------------------------------
File17 name   : apb_subsystem_pkg17.sv
Title17       : Module17 UVC17 Files17
Project17     : APB17 Subsystem17 Level17
Created17     :
Description17 : 
Notes17       : 
----------------------------------------------------------------------*/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_PKG_SV17
`define APB_SUBSYSTEM_PKG_SV17

package apb_subsystem_pkg17;

import uvm_pkg::*;
`include "uvm_macros.svh"

import ahb_pkg17::*;
import apb_pkg17::*;
import uart_pkg17::*;
import spi_pkg17::*;
import gpio_pkg17::*;
import uart_ctrl_pkg17::*;

`include "apb_subsystem_config17.sv"
//`include "reg_to_ahb_adapter17.sv"
`include "apb_subsystem_scoreboard17.sv"
`include "apb_subsystem_monitor17.sv"
`include "apb_subsystem_env17.sv"

endpackage : apb_subsystem_pkg17

`endif //APB_SUBSYSTEM_PKG_SV17
