/*-------------------------------------------------------------------------
File14 name   : uart_pkg14.svh
Title14       : Package14 for UART14 UVC14
Project14     :
Created14     :
Description14 : 
Notes14       :  
----------------------------------------------------------------------*/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------

  
`ifndef UART_PKG_SV14
`define UART_PKG_SV14

package uart_pkg14;

// Import14 the UVM library and include the UVM macros14
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "uart_config14.sv" 
`include "uart_frame14.sv"
`include "uart_monitor14.sv"
`include "uart_rx_monitor14.sv"
`include "uart_tx_monitor14.sv"
`include "uart_sequencer14.sv"
`include "uart_tx_driver14.sv"
`include "uart_rx_driver14.sv"
`include "uart_tx_agent14.sv"
`include "uart_rx_agent14.sv"
`include "uart_env14.sv"
`include "uart_seq_lib14.sv"

endpackage : uart_pkg14
`endif  // UART_PKG_SV14
