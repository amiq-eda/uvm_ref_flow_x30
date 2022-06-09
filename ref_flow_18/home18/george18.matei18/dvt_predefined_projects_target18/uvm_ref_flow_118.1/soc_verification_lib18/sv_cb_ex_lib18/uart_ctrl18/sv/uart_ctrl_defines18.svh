/*-------------------------------------------------------------------------
File18 name   : uart_ctrl_defines18.svh
Title18       : UART18 Controller18 defines18
Project18     :
Created18     :
Description18 : defines18 for the UART18 Controller18 Environment18
Notes18       : 
----------------------------------------------------------------------*/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------


`ifndef UART_CTRL_DEFINES_SVH18
`define UART_CTRL_DEFINES_SVH18

`define RX_FIFO_REG18 32'h00
`define TX_FIFO_REG18 32'h00
`define INTR_EN18 32'h01
`define INTR_ID18 32'h02
`define FIFO_CTRL18 32'h02
`define LINE_CTRL18 32'h03
`define MODM_CTRL18 32'h04
`define LINE_STAS18 32'h05
`define MODM_STAS18 32'h06

`define DIVD_LATCH118 32'h00
`define DIVD_LATCH218 32'h01

`define UA_TX_FIFO_DEPTH18 14

`endif
