/*-------------------------------------------------------------------------
File24 name   : apb_subsystem_pkg24.sv
Title24       : Module24 UVC24 Files24
Project24     : APB24 Subsystem24 Level24
Created24     :
Description24 : 
Notes24       : 
----------------------------------------------------------------------*/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_PKG_SV24
`define APB_SUBSYSTEM_PKG_SV24

package apb_subsystem_pkg24;

import uvm_pkg::*;
`include "uvm_macros.svh"

import ahb_pkg24::*;
import apb_pkg24::*;
import uart_pkg24::*;
import spi_pkg24::*;
import gpio_pkg24::*;
import uart_ctrl_pkg24::*;

`include "apb_subsystem_config24.sv"
//`include "reg_to_ahb_adapter24.sv"
`include "apb_subsystem_scoreboard24.sv"
`include "apb_subsystem_monitor24.sv"
`include "apb_subsystem_env24.sv"

endpackage : apb_subsystem_pkg24

`endif //APB_SUBSYSTEM_PKG_SV24
