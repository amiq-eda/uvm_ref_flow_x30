/*-------------------------------------------------------------------------
File13 name   : apb_subsystem_pkg13.sv
Title13       : Module13 UVC13 Files13
Project13     : APB13 Subsystem13 Level13
Created13     :
Description13 : 
Notes13       : 
----------------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_PKG_SV13
`define APB_SUBSYSTEM_PKG_SV13

package apb_subsystem_pkg13;

import uvm_pkg::*;
`include "uvm_macros.svh"

import ahb_pkg13::*;
import apb_pkg13::*;
import uart_pkg13::*;
import spi_pkg13::*;
import gpio_pkg13::*;
import uart_ctrl_pkg13::*;

`include "apb_subsystem_config13.sv"
//`include "reg_to_ahb_adapter13.sv"
`include "apb_subsystem_scoreboard13.sv"
`include "apb_subsystem_monitor13.sv"
`include "apb_subsystem_env13.sv"

endpackage : apb_subsystem_pkg13

`endif //APB_SUBSYSTEM_PKG_SV13
