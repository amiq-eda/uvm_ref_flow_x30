/*-------------------------------------------------------------------------
File21 name   : apb_subsystem_pkg21.sv
Title21       : Module21 UVC21 Files21
Project21     : APB21 Subsystem21 Level21
Created21     :
Description21 : 
Notes21       : 
----------------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_PKG_SV21
`define APB_SUBSYSTEM_PKG_SV21

package apb_subsystem_pkg21;

import uvm_pkg::*;
`include "uvm_macros.svh"

import ahb_pkg21::*;
import apb_pkg21::*;
import uart_pkg21::*;
import spi_pkg21::*;
import gpio_pkg21::*;
import uart_ctrl_pkg21::*;

`include "apb_subsystem_config21.sv"
//`include "reg_to_ahb_adapter21.sv"
`include "apb_subsystem_scoreboard21.sv"
`include "apb_subsystem_monitor21.sv"
`include "apb_subsystem_env21.sv"

endpackage : apb_subsystem_pkg21

`endif //APB_SUBSYSTEM_PKG_SV21
