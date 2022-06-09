/*-------------------------------------------------------------------------
File20 name   : apb_subsystem_pkg20.sv
Title20       : Module20 UVC20 Files20
Project20     : APB20 Subsystem20 Level20
Created20     :
Description20 : 
Notes20       : 
----------------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_PKG_SV20
`define APB_SUBSYSTEM_PKG_SV20

package apb_subsystem_pkg20;

import uvm_pkg::*;
`include "uvm_macros.svh"

import ahb_pkg20::*;
import apb_pkg20::*;
import uart_pkg20::*;
import spi_pkg20::*;
import gpio_pkg20::*;
import uart_ctrl_pkg20::*;

`include "apb_subsystem_config20.sv"
//`include "reg_to_ahb_adapter20.sv"
`include "apb_subsystem_scoreboard20.sv"
`include "apb_subsystem_monitor20.sv"
`include "apb_subsystem_env20.sv"

endpackage : apb_subsystem_pkg20

`endif //APB_SUBSYSTEM_PKG_SV20
