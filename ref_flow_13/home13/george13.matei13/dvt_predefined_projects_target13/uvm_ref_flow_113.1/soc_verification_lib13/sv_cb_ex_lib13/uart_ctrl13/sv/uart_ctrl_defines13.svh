/*-------------------------------------------------------------------------
File13 name   : uart_ctrl_defines13.svh
Title13       : UART13 Controller13 defines13
Project13     :
Created13     :
Description13 : defines13 for the UART13 Controller13 Environment13
Notes13       : 
----------------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------


`ifndef UART_CTRL_DEFINES_SVH13
`define UART_CTRL_DEFINES_SVH13

`define RX_FIFO_REG13 32'h00
`define TX_FIFO_REG13 32'h00
`define INTR_EN13 32'h01
`define INTR_ID13 32'h02
`define FIFO_CTRL13 32'h02
`define LINE_CTRL13 32'h03
`define MODM_CTRL13 32'h04
`define LINE_STAS13 32'h05
`define MODM_STAS13 32'h06

`define DIVD_LATCH113 32'h00
`define DIVD_LATCH213 32'h01

`define UA_TX_FIFO_DEPTH13 14

`endif
