/*-------------------------------------------------------------------------
File16 name   : uart_ctrl_defines16.svh
Title16       : UART16 Controller16 defines16
Project16     :
Created16     :
Description16 : defines16 for the UART16 Controller16 Environment16
Notes16       : 
----------------------------------------------------------------------*/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------


`ifndef UART_CTRL_DEFINES_SVH16
`define UART_CTRL_DEFINES_SVH16

`define RX_FIFO_REG16 32'h00
`define TX_FIFO_REG16 32'h00
`define INTR_EN16 32'h01
`define INTR_ID16 32'h02
`define FIFO_CTRL16 32'h02
`define LINE_CTRL16 32'h03
`define MODM_CTRL16 32'h04
`define LINE_STAS16 32'h05
`define MODM_STAS16 32'h06

`define DIVD_LATCH116 32'h00
`define DIVD_LATCH216 32'h01

`define UA_TX_FIFO_DEPTH16 14

`endif
