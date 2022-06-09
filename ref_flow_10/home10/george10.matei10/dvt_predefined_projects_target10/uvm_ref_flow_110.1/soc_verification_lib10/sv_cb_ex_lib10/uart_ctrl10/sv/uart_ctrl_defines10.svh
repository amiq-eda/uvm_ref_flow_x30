/*-------------------------------------------------------------------------
File10 name   : uart_ctrl_defines10.svh
Title10       : UART10 Controller10 defines10
Project10     :
Created10     :
Description10 : defines10 for the UART10 Controller10 Environment10
Notes10       : 
----------------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------


`ifndef UART_CTRL_DEFINES_SVH10
`define UART_CTRL_DEFINES_SVH10

`define RX_FIFO_REG10 32'h00
`define TX_FIFO_REG10 32'h00
`define INTR_EN10 32'h01
`define INTR_ID10 32'h02
`define FIFO_CTRL10 32'h02
`define LINE_CTRL10 32'h03
`define MODM_CTRL10 32'h04
`define LINE_STAS10 32'h05
`define MODM_STAS10 32'h06

`define DIVD_LATCH110 32'h00
`define DIVD_LATCH210 32'h01

`define UA_TX_FIFO_DEPTH10 14

`endif
