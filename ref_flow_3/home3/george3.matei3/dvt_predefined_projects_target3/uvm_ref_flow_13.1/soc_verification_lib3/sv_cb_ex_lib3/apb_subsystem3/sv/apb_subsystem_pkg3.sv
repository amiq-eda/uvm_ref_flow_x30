/*-------------------------------------------------------------------------
File3 name   : apb_subsystem_pkg3.sv
Title3       : Module3 UVC3 Files3
Project3     : APB3 Subsystem3 Level3
Created3     :
Description3 : 
Notes3       : 
----------------------------------------------------------------------*/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_PKG_SV3
`define APB_SUBSYSTEM_PKG_SV3

package apb_subsystem_pkg3;

import uvm_pkg::*;
`include "uvm_macros.svh"

import ahb_pkg3::*;
import apb_pkg3::*;
import uart_pkg3::*;
import spi_pkg3::*;
import gpio_pkg3::*;
import uart_ctrl_pkg3::*;

`include "apb_subsystem_config3.sv"
//`include "reg_to_ahb_adapter3.sv"
`include "apb_subsystem_scoreboard3.sv"
`include "apb_subsystem_monitor3.sv"
`include "apb_subsystem_env3.sv"

endpackage : apb_subsystem_pkg3

`endif //APB_SUBSYSTEM_PKG_SV3
