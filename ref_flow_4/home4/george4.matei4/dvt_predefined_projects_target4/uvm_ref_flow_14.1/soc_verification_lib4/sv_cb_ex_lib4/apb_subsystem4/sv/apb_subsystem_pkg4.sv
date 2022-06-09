/*-------------------------------------------------------------------------
File4 name   : apb_subsystem_pkg4.sv
Title4       : Module4 UVC4 Files4
Project4     : APB4 Subsystem4 Level4
Created4     :
Description4 : 
Notes4       : 
----------------------------------------------------------------------*/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_PKG_SV4
`define APB_SUBSYSTEM_PKG_SV4

package apb_subsystem_pkg4;

import uvm_pkg::*;
`include "uvm_macros.svh"

import ahb_pkg4::*;
import apb_pkg4::*;
import uart_pkg4::*;
import spi_pkg4::*;
import gpio_pkg4::*;
import uart_ctrl_pkg4::*;

`include "apb_subsystem_config4.sv"
//`include "reg_to_ahb_adapter4.sv"
`include "apb_subsystem_scoreboard4.sv"
`include "apb_subsystem_monitor4.sv"
`include "apb_subsystem_env4.sv"

endpackage : apb_subsystem_pkg4

`endif //APB_SUBSYSTEM_PKG_SV4
