/*-------------------------------------------------------------------------
File23 name   : uart_ctrl_defines23.svh
Title23       : UART23 Controller23 defines23
Project23     :
Created23     :
Description23 : defines23 for the UART23 Controller23 Environment23
Notes23       : 
----------------------------------------------------------------------*/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------


`ifndef UART_CTRL_DEFINES_SVH23
`define UART_CTRL_DEFINES_SVH23

`define RX_FIFO_REG23 32'h00
`define TX_FIFO_REG23 32'h00
`define INTR_EN23 32'h01
`define INTR_ID23 32'h02
`define FIFO_CTRL23 32'h02
`define LINE_CTRL23 32'h03
`define MODM_CTRL23 32'h04
`define LINE_STAS23 32'h05
`define MODM_STAS23 32'h06

`define DIVD_LATCH123 32'h00
`define DIVD_LATCH223 32'h01

`define UA_TX_FIFO_DEPTH23 14

`endif
