/*-------------------------------------------------------------------------
File23 name   : apb_subsystem_pkg23.sv
Title23       : Module23 UVC23 Files23
Project23     : APB23 Subsystem23 Level23
Created23     :
Description23 : 
Notes23       : 
----------------------------------------------------------------------*/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_PKG_SV23
`define APB_SUBSYSTEM_PKG_SV23

package apb_subsystem_pkg23;

import uvm_pkg::*;
`include "uvm_macros.svh"

import ahb_pkg23::*;
import apb_pkg23::*;
import uart_pkg23::*;
import spi_pkg23::*;
import gpio_pkg23::*;
import uart_ctrl_pkg23::*;

`include "apb_subsystem_config23.sv"
//`include "reg_to_ahb_adapter23.sv"
`include "apb_subsystem_scoreboard23.sv"
`include "apb_subsystem_monitor23.sv"
`include "apb_subsystem_env23.sv"

endpackage : apb_subsystem_pkg23

`endif //APB_SUBSYSTEM_PKG_SV23
