/*-------------------------------------------------------------------------
File29 name   : uart_pkg29.svh
Title29       : Package29 for UART29 UVC29
Project29     :
Created29     :
Description29 : 
Notes29       :  
----------------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------

  
`ifndef UART_PKG_SV29
`define UART_PKG_SV29

package uart_pkg29;

// Import29 the UVM library and include the UVM macros29
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "uart_config29.sv" 
`include "uart_frame29.sv"
`include "uart_monitor29.sv"
`include "uart_rx_monitor29.sv"
`include "uart_tx_monitor29.sv"
`include "uart_sequencer29.sv"
`include "uart_tx_driver29.sv"
`include "uart_rx_driver29.sv"
`include "uart_tx_agent29.sv"
`include "uart_rx_agent29.sv"
`include "uart_env29.sv"
`include "uart_seq_lib29.sv"

endpackage : uart_pkg29
`endif  // UART_PKG_SV29
