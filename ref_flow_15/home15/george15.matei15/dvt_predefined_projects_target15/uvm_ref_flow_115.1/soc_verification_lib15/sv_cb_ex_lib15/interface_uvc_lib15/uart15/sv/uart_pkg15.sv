/*-------------------------------------------------------------------------
File15 name   : uart_pkg15.svh
Title15       : Package15 for UART15 UVC15
Project15     :
Created15     :
Description15 : 
Notes15       :  
----------------------------------------------------------------------*/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------

  
`ifndef UART_PKG_SV15
`define UART_PKG_SV15

package uart_pkg15;

// Import15 the UVM library and include the UVM macros15
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "uart_config15.sv" 
`include "uart_frame15.sv"
`include "uart_monitor15.sv"
`include "uart_rx_monitor15.sv"
`include "uart_tx_monitor15.sv"
`include "uart_sequencer15.sv"
`include "uart_tx_driver15.sv"
`include "uart_rx_driver15.sv"
`include "uart_tx_agent15.sv"
`include "uart_rx_agent15.sv"
`include "uart_env15.sv"
`include "uart_seq_lib15.sv"

endpackage : uart_pkg15
`endif  // UART_PKG_SV15
