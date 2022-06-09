/*-------------------------------------------------------------------------
File4 name   : uart_pkg4.svh
Title4       : Package4 for UART4 UVC4
Project4     :
Created4     :
Description4 : 
Notes4       :  
----------------------------------------------------------------------*/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------

  
`ifndef UART_PKG_SV4
`define UART_PKG_SV4

package uart_pkg4;

// Import4 the UVM library and include the UVM macros4
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "uart_config4.sv" 
`include "uart_frame4.sv"
`include "uart_monitor4.sv"
`include "uart_rx_monitor4.sv"
`include "uart_tx_monitor4.sv"
`include "uart_sequencer4.sv"
`include "uart_tx_driver4.sv"
`include "uart_rx_driver4.sv"
`include "uart_tx_agent4.sv"
`include "uart_rx_agent4.sv"
`include "uart_env4.sv"
`include "uart_seq_lib4.sv"

endpackage : uart_pkg4
`endif  // UART_PKG_SV4
