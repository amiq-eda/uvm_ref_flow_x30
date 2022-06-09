/*-------------------------------------------------------------------------
File24 name   : uart_ctrl_defines24.svh
Title24       : UART24 Controller24 defines24
Project24     :
Created24     :
Description24 : defines24 for the UART24 Controller24 Environment24
Notes24       : 
----------------------------------------------------------------------*/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------


`ifndef UART_CTRL_DEFINES_SVH24
`define UART_CTRL_DEFINES_SVH24

`define RX_FIFO_REG24 32'h00
`define TX_FIFO_REG24 32'h00
`define INTR_EN24 32'h01
`define INTR_ID24 32'h02
`define FIFO_CTRL24 32'h02
`define LINE_CTRL24 32'h03
`define MODM_CTRL24 32'h04
`define LINE_STAS24 32'h05
`define MODM_STAS24 32'h06

`define DIVD_LATCH124 32'h00
`define DIVD_LATCH224 32'h01

`define UA_TX_FIFO_DEPTH24 14

`endif
