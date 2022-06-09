/*-------------------------------------------------------------------------
File9 name   : uart_ctrl_defines9.svh
Title9       : UART9 Controller9 defines9
Project9     :
Created9     :
Description9 : defines9 for the UART9 Controller9 Environment9
Notes9       : 
----------------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------


`ifndef UART_CTRL_DEFINES_SVH9
`define UART_CTRL_DEFINES_SVH9

`define RX_FIFO_REG9 32'h00
`define TX_FIFO_REG9 32'h00
`define INTR_EN9 32'h01
`define INTR_ID9 32'h02
`define FIFO_CTRL9 32'h02
`define LINE_CTRL9 32'h03
`define MODM_CTRL9 32'h04
`define LINE_STAS9 32'h05
`define MODM_STAS9 32'h06

`define DIVD_LATCH19 32'h00
`define DIVD_LATCH29 32'h01

`define UA_TX_FIFO_DEPTH9 14

`endif
