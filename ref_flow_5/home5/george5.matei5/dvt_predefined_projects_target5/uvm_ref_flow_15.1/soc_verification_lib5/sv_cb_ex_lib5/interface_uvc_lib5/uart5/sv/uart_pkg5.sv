/*-------------------------------------------------------------------------
File5 name   : uart_pkg5.svh
Title5       : Package5 for UART5 UVC5
Project5     :
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

  
`ifndef UART_PKG_SV5
`define UART_PKG_SV5

package uart_pkg5;

// Import5 the UVM library and include the UVM macros5
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "uart_config5.sv" 
`include "uart_frame5.sv"
`include "uart_monitor5.sv"
`include "uart_rx_monitor5.sv"
`include "uart_tx_monitor5.sv"
`include "uart_sequencer5.sv"
`include "uart_tx_driver5.sv"
`include "uart_rx_driver5.sv"
`include "uart_tx_agent5.sv"
`include "uart_rx_agent5.sv"
`include "uart_env5.sv"
`include "uart_seq_lib5.sv"

endpackage : uart_pkg5
`endif  // UART_PKG_SV5
