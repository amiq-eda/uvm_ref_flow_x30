/*-------------------------------------------------------------------------
File29 name   : apb_subsystem_pkg29.sv
Title29       : Module29 UVC29 Files29
Project29     : APB29 Subsystem29 Level29
Created29     :
Description29 : 
Notes29       : 
----------------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_PKG_SV29
`define APB_SUBSYSTEM_PKG_SV29

package apb_subsystem_pkg29;

import uvm_pkg::*;
`include "uvm_macros.svh"

import ahb_pkg29::*;
import apb_pkg29::*;
import uart_pkg29::*;
import spi_pkg29::*;
import gpio_pkg29::*;
import uart_ctrl_pkg29::*;

`include "apb_subsystem_config29.sv"
//`include "reg_to_ahb_adapter29.sv"
`include "apb_subsystem_scoreboard29.sv"
`include "apb_subsystem_monitor29.sv"
`include "apb_subsystem_env29.sv"

endpackage : apb_subsystem_pkg29

`endif //APB_SUBSYSTEM_PKG_SV29
