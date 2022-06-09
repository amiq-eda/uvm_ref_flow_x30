/*-------------------------------------------------------------------------
File22 name   : uart_ctrl_defines22.svh
Title22       : UART22 Controller22 defines22
Project22     :
Created22     :
Description22 : defines22 for the UART22 Controller22 Environment22
Notes22       : 
----------------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------


`ifndef UART_CTRL_DEFINES_SVH22
`define UART_CTRL_DEFINES_SVH22

`define RX_FIFO_REG22 32'h00
`define TX_FIFO_REG22 32'h00
`define INTR_EN22 32'h01
`define INTR_ID22 32'h02
`define FIFO_CTRL22 32'h02
`define LINE_CTRL22 32'h03
`define MODM_CTRL22 32'h04
`define LINE_STAS22 32'h05
`define MODM_STAS22 32'h06

`define DIVD_LATCH122 32'h00
`define DIVD_LATCH222 32'h01

`define UA_TX_FIFO_DEPTH22 14

`endif
