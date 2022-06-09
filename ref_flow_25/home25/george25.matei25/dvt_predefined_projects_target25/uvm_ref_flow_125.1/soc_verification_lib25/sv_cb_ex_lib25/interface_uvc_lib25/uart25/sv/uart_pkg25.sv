/*-------------------------------------------------------------------------
File25 name   : uart_pkg25.svh
Title25       : Package25 for UART25 UVC25
Project25     :
Created25     :
Description25 : 
Notes25       :  
----------------------------------------------------------------------*/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------

  
`ifndef UART_PKG_SV25
`define UART_PKG_SV25

package uart_pkg25;

// Import25 the UVM library and include the UVM macros25
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "uart_config25.sv" 
`include "uart_frame25.sv"
`include "uart_monitor25.sv"
`include "uart_rx_monitor25.sv"
`include "uart_tx_monitor25.sv"
`include "uart_sequencer25.sv"
`include "uart_tx_driver25.sv"
`include "uart_rx_driver25.sv"
`include "uart_tx_agent25.sv"
`include "uart_rx_agent25.sv"
`include "uart_env25.sv"
`include "uart_seq_lib25.sv"

endpackage : uart_pkg25
`endif  // UART_PKG_SV25
