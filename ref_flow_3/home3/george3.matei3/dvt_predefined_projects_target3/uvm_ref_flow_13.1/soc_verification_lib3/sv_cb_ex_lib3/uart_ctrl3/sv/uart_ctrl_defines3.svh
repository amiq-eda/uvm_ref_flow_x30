/*-------------------------------------------------------------------------
File3 name   : uart_ctrl_defines3.svh
Title3       : UART3 Controller3 defines3
Project3     :
Created3     :
Description3 : defines3 for the UART3 Controller3 Environment3
Notes3       : 
----------------------------------------------------------------------*/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------


`ifndef UART_CTRL_DEFINES_SVH3
`define UART_CTRL_DEFINES_SVH3

`define RX_FIFO_REG3 32'h00
`define TX_FIFO_REG3 32'h00
`define INTR_EN3 32'h01
`define INTR_ID3 32'h02
`define FIFO_CTRL3 32'h02
`define LINE_CTRL3 32'h03
`define MODM_CTRL3 32'h04
`define LINE_STAS3 32'h05
`define MODM_STAS3 32'h06

`define DIVD_LATCH13 32'h00
`define DIVD_LATCH23 32'h01

`define UA_TX_FIFO_DEPTH3 14

`endif
