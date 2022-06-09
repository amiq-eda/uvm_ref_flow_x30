/*-------------------------------------------------------------------------
File16 name   : uart_pkg16.svh
Title16       : Package16 for UART16 UVC16
Project16     :
Created16     :
Description16 : 
Notes16       :  
----------------------------------------------------------------------*/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------

  
`ifndef UART_PKG_SV16
`define UART_PKG_SV16

package uart_pkg16;

// Import16 the UVM library and include the UVM macros16
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "uart_config16.sv" 
`include "uart_frame16.sv"
`include "uart_monitor16.sv"
`include "uart_rx_monitor16.sv"
`include "uart_tx_monitor16.sv"
`include "uart_sequencer16.sv"
`include "uart_tx_driver16.sv"
`include "uart_rx_driver16.sv"
`include "uart_tx_agent16.sv"
`include "uart_rx_agent16.sv"
`include "uart_env16.sv"
`include "uart_seq_lib16.sv"

endpackage : uart_pkg16
`endif  // UART_PKG_SV16
