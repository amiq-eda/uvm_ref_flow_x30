/*-------------------------------------------------------------------------
File30 name   : apb_subsystem_pkg30.sv
Title30       : Module30 UVC30 Files30
Project30     : APB30 Subsystem30 Level30
Created30     :
Description30 : 
Notes30       : 
----------------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_PKG_SV30
`define APB_SUBSYSTEM_PKG_SV30

package apb_subsystem_pkg30;

import uvm_pkg::*;
`include "uvm_macros.svh"

import ahb_pkg30::*;
import apb_pkg30::*;
import uart_pkg30::*;
import spi_pkg30::*;
import gpio_pkg30::*;
import uart_ctrl_pkg30::*;

`include "apb_subsystem_config30.sv"
//`include "reg_to_ahb_adapter30.sv"
`include "apb_subsystem_scoreboard30.sv"
`include "apb_subsystem_monitor30.sv"
`include "apb_subsystem_env30.sv"

endpackage : apb_subsystem_pkg30

`endif //APB_SUBSYSTEM_PKG_SV30
