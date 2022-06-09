/*-------------------------------------------------------------------------
File8 name   : uart_ctrl_defines8.svh
Title8       : UART8 Controller8 defines8
Project8     :
Created8     :
Description8 : defines8 for the UART8 Controller8 Environment8
Notes8       : 
----------------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------


`ifndef UART_CTRL_DEFINES_SVH8
`define UART_CTRL_DEFINES_SVH8

`define RX_FIFO_REG8 32'h00
`define TX_FIFO_REG8 32'h00
`define INTR_EN8 32'h01
`define INTR_ID8 32'h02
`define FIFO_CTRL8 32'h02
`define LINE_CTRL8 32'h03
`define MODM_CTRL8 32'h04
`define LINE_STAS8 32'h05
`define MODM_STAS8 32'h06

`define DIVD_LATCH18 32'h00
`define DIVD_LATCH28 32'h01

`define UA_TX_FIFO_DEPTH8 14

`endif
