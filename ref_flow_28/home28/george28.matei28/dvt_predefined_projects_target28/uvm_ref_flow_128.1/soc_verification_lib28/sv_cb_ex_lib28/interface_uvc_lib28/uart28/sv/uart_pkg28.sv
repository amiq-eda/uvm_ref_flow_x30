/*-------------------------------------------------------------------------
File28 name   : uart_pkg28.svh
Title28       : Package28 for UART28 UVC28
Project28     :
Created28     :
Description28 : 
Notes28       :  
----------------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------

  
`ifndef UART_PKG_SV28
`define UART_PKG_SV28

package uart_pkg28;

// Import28 the UVM library and include the UVM macros28
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "uart_config28.sv" 
`include "uart_frame28.sv"
`include "uart_monitor28.sv"
`include "uart_rx_monitor28.sv"
`include "uart_tx_monitor28.sv"
`include "uart_sequencer28.sv"
`include "uart_tx_driver28.sv"
`include "uart_rx_driver28.sv"
`include "uart_tx_agent28.sv"
`include "uart_rx_agent28.sv"
`include "uart_env28.sv"
`include "uart_seq_lib28.sv"

endpackage : uart_pkg28
`endif  // UART_PKG_SV28
