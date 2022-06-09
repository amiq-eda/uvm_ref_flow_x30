/*-------------------------------------------------------------------------
File28 name   : apb_subsystem_pkg28.sv
Title28       : Module28 UVC28 Files28
Project28     : APB28 Subsystem28 Level28
Created28     :
Description28 : 
Notes28       : 
----------------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_PKG_SV28
`define APB_SUBSYSTEM_PKG_SV28

package apb_subsystem_pkg28;

import uvm_pkg::*;
`include "uvm_macros.svh"

import ahb_pkg28::*;
import apb_pkg28::*;
import uart_pkg28::*;
import spi_pkg28::*;
import gpio_pkg28::*;
import uart_ctrl_pkg28::*;

`include "apb_subsystem_config28.sv"
//`include "reg_to_ahb_adapter28.sv"
`include "apb_subsystem_scoreboard28.sv"
`include "apb_subsystem_monitor28.sv"
`include "apb_subsystem_env28.sv"

endpackage : apb_subsystem_pkg28

`endif //APB_SUBSYSTEM_PKG_SV28
