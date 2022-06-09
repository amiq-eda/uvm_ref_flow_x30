/*-------------------------------------------------------------------------
File5 name   : apb_subsystem_pkg5.sv
Title5       : Module5 UVC5 Files5
Project5     : APB5 Subsystem5 Level5
Created5     :
Description5 : 
Notes5       : 
----------------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_PKG_SV5
`define APB_SUBSYSTEM_PKG_SV5

package apb_subsystem_pkg5;

import uvm_pkg::*;
`include "uvm_macros.svh"

import ahb_pkg5::*;
import apb_pkg5::*;
import uart_pkg5::*;
import spi_pkg5::*;
import gpio_pkg5::*;
import uart_ctrl_pkg5::*;

`include "apb_subsystem_config5.sv"
//`include "reg_to_ahb_adapter5.sv"
`include "apb_subsystem_scoreboard5.sv"
`include "apb_subsystem_monitor5.sv"
`include "apb_subsystem_env5.sv"

endpackage : apb_subsystem_pkg5

`endif //APB_SUBSYSTEM_PKG_SV5
