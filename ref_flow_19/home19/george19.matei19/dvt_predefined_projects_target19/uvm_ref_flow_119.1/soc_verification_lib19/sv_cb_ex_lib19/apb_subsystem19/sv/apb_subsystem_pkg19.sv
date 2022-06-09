/*-------------------------------------------------------------------------
File19 name   : apb_subsystem_pkg19.sv
Title19       : Module19 UVC19 Files19
Project19     : APB19 Subsystem19 Level19
Created19     :
Description19 : 
Notes19       : 
----------------------------------------------------------------------*/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_PKG_SV19
`define APB_SUBSYSTEM_PKG_SV19

package apb_subsystem_pkg19;

import uvm_pkg::*;
`include "uvm_macros.svh"

import ahb_pkg19::*;
import apb_pkg19::*;
import uart_pkg19::*;
import spi_pkg19::*;
import gpio_pkg19::*;
import uart_ctrl_pkg19::*;

`include "apb_subsystem_config19.sv"
//`include "reg_to_ahb_adapter19.sv"
`include "apb_subsystem_scoreboard19.sv"
`include "apb_subsystem_monitor19.sv"
`include "apb_subsystem_env19.sv"

endpackage : apb_subsystem_pkg19

`endif //APB_SUBSYSTEM_PKG_SV19
