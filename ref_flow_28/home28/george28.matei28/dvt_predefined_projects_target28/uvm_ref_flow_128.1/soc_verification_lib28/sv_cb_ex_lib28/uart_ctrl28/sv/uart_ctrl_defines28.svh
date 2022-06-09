/*-------------------------------------------------------------------------
File28 name   : uart_ctrl_defines28.svh
Title28       : UART28 Controller28 defines28
Project28     :
Created28     :
Description28 : defines28 for the UART28 Controller28 Environment28
Notes28       : 
----------------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------


`ifndef UART_CTRL_DEFINES_SVH28
`define UART_CTRL_DEFINES_SVH28

`define RX_FIFO_REG28 32'h00
`define TX_FIFO_REG28 32'h00
`define INTR_EN28 32'h01
`define INTR_ID28 32'h02
`define FIFO_CTRL28 32'h02
`define LINE_CTRL28 32'h03
`define MODM_CTRL28 32'h04
`define LINE_STAS28 32'h05
`define MODM_STAS28 32'h06

`define DIVD_LATCH128 32'h00
`define DIVD_LATCH228 32'h01

`define UA_TX_FIFO_DEPTH28 14

`endif
