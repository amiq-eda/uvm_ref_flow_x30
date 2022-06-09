/*-------------------------------------------------------------------------
File26 name   : uart_pkg26.svh
Title26       : Package26 for UART26 UVC26
Project26     :
Created26     :
Description26 : 
Notes26       :  
----------------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------

  
`ifndef UART_PKG_SV26
`define UART_PKG_SV26

package uart_pkg26;

// Import26 the UVM library and include the UVM macros26
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "uart_config26.sv" 
`include "uart_frame26.sv"
`include "uart_monitor26.sv"
`include "uart_rx_monitor26.sv"
`include "uart_tx_monitor26.sv"
`include "uart_sequencer26.sv"
`include "uart_tx_driver26.sv"
`include "uart_rx_driver26.sv"
`include "uart_tx_agent26.sv"
`include "uart_rx_agent26.sv"
`include "uart_env26.sv"
`include "uart_seq_lib26.sv"

endpackage : uart_pkg26
`endif  // UART_PKG_SV26
