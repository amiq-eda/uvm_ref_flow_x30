/*-------------------------------------------------------------------------
File18 name   : apb_subsystem_pkg18.sv
Title18       : Module18 UVC18 Files18
Project18     : APB18 Subsystem18 Level18
Created18     :
Description18 : 
Notes18       : 
----------------------------------------------------------------------*/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_PKG_SV18
`define APB_SUBSYSTEM_PKG_SV18

package apb_subsystem_pkg18;

import uvm_pkg::*;
`include "uvm_macros.svh"

import ahb_pkg18::*;
import apb_pkg18::*;
import uart_pkg18::*;
import spi_pkg18::*;
import gpio_pkg18::*;
import uart_ctrl_pkg18::*;

`include "apb_subsystem_config18.sv"
//`include "reg_to_ahb_adapter18.sv"
`include "apb_subsystem_scoreboard18.sv"
`include "apb_subsystem_monitor18.sv"
`include "apb_subsystem_env18.sv"

endpackage : apb_subsystem_pkg18

`endif //APB_SUBSYSTEM_PKG_SV18
