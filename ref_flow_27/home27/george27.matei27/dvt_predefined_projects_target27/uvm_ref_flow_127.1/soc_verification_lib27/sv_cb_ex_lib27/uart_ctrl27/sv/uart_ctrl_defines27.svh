/*-------------------------------------------------------------------------
File27 name   : uart_ctrl_defines27.svh
Title27       : UART27 Controller27 defines27
Project27     :
Created27     :
Description27 : defines27 for the UART27 Controller27 Environment27
Notes27       : 
----------------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


`ifndef UART_CTRL_DEFINES_SVH27
`define UART_CTRL_DEFINES_SVH27

`define RX_FIFO_REG27 32'h00
`define TX_FIFO_REG27 32'h00
`define INTR_EN27 32'h01
`define INTR_ID27 32'h02
`define FIFO_CTRL27 32'h02
`define LINE_CTRL27 32'h03
`define MODM_CTRL27 32'h04
`define LINE_STAS27 32'h05
`define MODM_STAS27 32'h06

`define DIVD_LATCH127 32'h00
`define DIVD_LATCH227 32'h01

`define UA_TX_FIFO_DEPTH27 14

`endif
