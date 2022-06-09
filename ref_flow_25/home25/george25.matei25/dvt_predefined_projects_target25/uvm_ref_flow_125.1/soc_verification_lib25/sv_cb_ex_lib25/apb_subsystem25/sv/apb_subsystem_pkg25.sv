/*-------------------------------------------------------------------------
File25 name   : apb_subsystem_pkg25.sv
Title25       : Module25 UVC25 Files25
Project25     : APB25 Subsystem25 Level25
Created25     :
Description25 : 
Notes25       : 
----------------------------------------------------------------------*/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_PKG_SV25
`define APB_SUBSYSTEM_PKG_SV25

package apb_subsystem_pkg25;

import uvm_pkg::*;
`include "uvm_macros.svh"

import ahb_pkg25::*;
import apb_pkg25::*;
import uart_pkg25::*;
import spi_pkg25::*;
import gpio_pkg25::*;
import uart_ctrl_pkg25::*;

`include "apb_subsystem_config25.sv"
//`include "reg_to_ahb_adapter25.sv"
`include "apb_subsystem_scoreboard25.sv"
`include "apb_subsystem_monitor25.sv"
`include "apb_subsystem_env25.sv"

endpackage : apb_subsystem_pkg25

`endif //APB_SUBSYSTEM_PKG_SV25
