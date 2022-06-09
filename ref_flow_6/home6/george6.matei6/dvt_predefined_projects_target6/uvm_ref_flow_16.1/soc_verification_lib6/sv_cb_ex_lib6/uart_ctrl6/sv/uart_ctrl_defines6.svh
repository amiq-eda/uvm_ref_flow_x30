/*-------------------------------------------------------------------------
File6 name   : uart_ctrl_defines6.svh
Title6       : UART6 Controller6 defines6
Project6     :
Created6     :
Description6 : defines6 for the UART6 Controller6 Environment6
Notes6       : 
----------------------------------------------------------------------*/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------


`ifndef UART_CTRL_DEFINES_SVH6
`define UART_CTRL_DEFINES_SVH6

`define RX_FIFO_REG6 32'h00
`define TX_FIFO_REG6 32'h00
`define INTR_EN6 32'h01
`define INTR_ID6 32'h02
`define FIFO_CTRL6 32'h02
`define LINE_CTRL6 32'h03
`define MODM_CTRL6 32'h04
`define LINE_STAS6 32'h05
`define MODM_STAS6 32'h06

`define DIVD_LATCH16 32'h00
`define DIVD_LATCH26 32'h01

`define UA_TX_FIFO_DEPTH6 14

`endif
