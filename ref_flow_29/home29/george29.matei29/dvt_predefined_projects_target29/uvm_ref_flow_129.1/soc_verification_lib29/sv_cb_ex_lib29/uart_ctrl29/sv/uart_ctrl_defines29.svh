/*-------------------------------------------------------------------------
File29 name   : uart_ctrl_defines29.svh
Title29       : UART29 Controller29 defines29
Project29     :
Created29     :
Description29 : defines29 for the UART29 Controller29 Environment29
Notes29       : 
----------------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------


`ifndef UART_CTRL_DEFINES_SVH29
`define UART_CTRL_DEFINES_SVH29

`define RX_FIFO_REG29 32'h00
`define TX_FIFO_REG29 32'h00
`define INTR_EN29 32'h01
`define INTR_ID29 32'h02
`define FIFO_CTRL29 32'h02
`define LINE_CTRL29 32'h03
`define MODM_CTRL29 32'h04
`define LINE_STAS29 32'h05
`define MODM_STAS29 32'h06

`define DIVD_LATCH129 32'h00
`define DIVD_LATCH229 32'h01

`define UA_TX_FIFO_DEPTH29 14

`endif
