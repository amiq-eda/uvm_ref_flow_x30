/*-------------------------------------------------------------------------
File9 name   : apb_subsystem_pkg9.sv
Title9       : Module9 UVC9 Files9
Project9     : APB9 Subsystem9 Level9
Created9     :
Description9 : 
Notes9       : 
----------------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_PKG_SV9
`define APB_SUBSYSTEM_PKG_SV9

package apb_subsystem_pkg9;

import uvm_pkg::*;
`include "uvm_macros.svh"

import ahb_pkg9::*;
import apb_pkg9::*;
import uart_pkg9::*;
import spi_pkg9::*;
import gpio_pkg9::*;
import uart_ctrl_pkg9::*;

`include "apb_subsystem_config9.sv"
//`include "reg_to_ahb_adapter9.sv"
`include "apb_subsystem_scoreboard9.sv"
`include "apb_subsystem_monitor9.sv"
`include "apb_subsystem_env9.sv"

endpackage : apb_subsystem_pkg9

`endif //APB_SUBSYSTEM_PKG_SV9
