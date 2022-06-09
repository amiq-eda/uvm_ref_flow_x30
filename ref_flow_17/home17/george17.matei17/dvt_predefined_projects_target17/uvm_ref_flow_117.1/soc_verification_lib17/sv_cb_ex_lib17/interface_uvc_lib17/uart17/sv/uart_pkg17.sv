/*-------------------------------------------------------------------------
File17 name   : uart_pkg17.svh
Title17       : Package17 for UART17 UVC17
Project17     :
Created17     :
Description17 : 
Notes17       :  
----------------------------------------------------------------------*/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------

  
`ifndef UART_PKG_SV17
`define UART_PKG_SV17

package uart_pkg17;

// Import17 the UVM library and include the UVM macros17
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "uart_config17.sv" 
`include "uart_frame17.sv"
`include "uart_monitor17.sv"
`include "uart_rx_monitor17.sv"
`include "uart_tx_monitor17.sv"
`include "uart_sequencer17.sv"
`include "uart_tx_driver17.sv"
`include "uart_rx_driver17.sv"
`include "uart_tx_agent17.sv"
`include "uart_rx_agent17.sv"
`include "uart_env17.sv"
`include "uart_seq_lib17.sv"

endpackage : uart_pkg17
`endif  // UART_PKG_SV17
