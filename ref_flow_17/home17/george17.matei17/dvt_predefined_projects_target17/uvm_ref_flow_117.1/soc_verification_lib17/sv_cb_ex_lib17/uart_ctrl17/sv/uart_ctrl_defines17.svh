/*-------------------------------------------------------------------------
File17 name   : uart_ctrl_defines17.svh
Title17       : UART17 Controller17 defines17
Project17     :
Created17     :
Description17 : defines17 for the UART17 Controller17 Environment17
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


`ifndef UART_CTRL_DEFINES_SVH17
`define UART_CTRL_DEFINES_SVH17

`define RX_FIFO_REG17 32'h00
`define TX_FIFO_REG17 32'h00
`define INTR_EN17 32'h01
`define INTR_ID17 32'h02
`define FIFO_CTRL17 32'h02
`define LINE_CTRL17 32'h03
`define MODM_CTRL17 32'h04
`define LINE_STAS17 32'h05
`define MODM_STAS17 32'h06

`define DIVD_LATCH117 32'h00
`define DIVD_LATCH217 32'h01

`define UA_TX_FIFO_DEPTH17 14

`endif
