/*-------------------------------------------------------------------------
File12 name   : uart_pkg12.svh
Title12       : Package12 for UART12 UVC12
Project12     :
Created12     :
Description12 : 
Notes12       :  
----------------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------

  
`ifndef UART_PKG_SV12
`define UART_PKG_SV12

package uart_pkg12;

// Import12 the UVM library and include the UVM macros12
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "uart_config12.sv" 
`include "uart_frame12.sv"
`include "uart_monitor12.sv"
`include "uart_rx_monitor12.sv"
`include "uart_tx_monitor12.sv"
`include "uart_sequencer12.sv"
`include "uart_tx_driver12.sv"
`include "uart_rx_driver12.sv"
`include "uart_tx_agent12.sv"
`include "uart_rx_agent12.sv"
`include "uart_env12.sv"
`include "uart_seq_lib12.sv"

endpackage : uart_pkg12
`endif  // UART_PKG_SV12
