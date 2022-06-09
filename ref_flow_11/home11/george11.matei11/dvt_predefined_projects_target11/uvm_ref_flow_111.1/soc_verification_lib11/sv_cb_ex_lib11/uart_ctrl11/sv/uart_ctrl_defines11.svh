/*-------------------------------------------------------------------------
File11 name   : uart_ctrl_defines11.svh
Title11       : UART11 Controller11 defines11
Project11     :
Created11     :
Description11 : defines11 for the UART11 Controller11 Environment11
Notes11       : 
----------------------------------------------------------------------*/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------


`ifndef UART_CTRL_DEFINES_SVH11
`define UART_CTRL_DEFINES_SVH11

`define RX_FIFO_REG11 32'h00
`define TX_FIFO_REG11 32'h00
`define INTR_EN11 32'h01
`define INTR_ID11 32'h02
`define FIFO_CTRL11 32'h02
`define LINE_CTRL11 32'h03
`define MODM_CTRL11 32'h04
`define LINE_STAS11 32'h05
`define MODM_STAS11 32'h06

`define DIVD_LATCH111 32'h00
`define DIVD_LATCH211 32'h01

`define UA_TX_FIFO_DEPTH11 14

`endif
