/*-------------------------------------------------------------------------
File20 name   : uart_pkg20.svh
Title20       : Package20 for UART20 UVC20
Project20     :
Created20     :
Description20 : 
Notes20       :  
----------------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------

  
`ifndef UART_PKG_SV20
`define UART_PKG_SV20

package uart_pkg20;

// Import20 the UVM library and include the UVM macros20
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "uart_config20.sv" 
`include "uart_frame20.sv"
`include "uart_monitor20.sv"
`include "uart_rx_monitor20.sv"
`include "uart_tx_monitor20.sv"
`include "uart_sequencer20.sv"
`include "uart_tx_driver20.sv"
`include "uart_rx_driver20.sv"
`include "uart_tx_agent20.sv"
`include "uart_rx_agent20.sv"
`include "uart_env20.sv"
`include "uart_seq_lib20.sv"

endpackage : uart_pkg20
`endif  // UART_PKG_SV20
