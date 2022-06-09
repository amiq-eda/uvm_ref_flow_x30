/*-------------------------------------------------------------------------
File23 name   : uart_pkg23.svh
Title23       : Package23 for UART23 UVC23
Project23     :
Created23     :
Description23 : 
Notes23       :  
----------------------------------------------------------------------*/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------

  
`ifndef UART_PKG_SV23
`define UART_PKG_SV23

package uart_pkg23;

// Import23 the UVM library and include the UVM macros23
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "uart_config23.sv" 
`include "uart_frame23.sv"
`include "uart_monitor23.sv"
`include "uart_rx_monitor23.sv"
`include "uart_tx_monitor23.sv"
`include "uart_sequencer23.sv"
`include "uart_tx_driver23.sv"
`include "uart_rx_driver23.sv"
`include "uart_tx_agent23.sv"
`include "uart_rx_agent23.sv"
`include "uart_env23.sv"
`include "uart_seq_lib23.sv"

endpackage : uart_pkg23
`endif  // UART_PKG_SV23
