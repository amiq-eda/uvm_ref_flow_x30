/*-------------------------------------------------------------------------
File20 name   : uart_ctrl_defines20.svh
Title20       : UART20 Controller20 defines20
Project20     :
Created20     :
Description20 : defines20 for the UART20 Controller20 Environment20
Notes20       : 
----------------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------


`ifndef UART_CTRL_DEFINES_SVH20
`define UART_CTRL_DEFINES_SVH20

`define RX_FIFO_REG20 32'h00
`define TX_FIFO_REG20 32'h00
`define INTR_EN20 32'h01
`define INTR_ID20 32'h02
`define FIFO_CTRL20 32'h02
`define LINE_CTRL20 32'h03
`define MODM_CTRL20 32'h04
`define LINE_STAS20 32'h05
`define MODM_STAS20 32'h06

`define DIVD_LATCH120 32'h00
`define DIVD_LATCH220 32'h01

`define UA_TX_FIFO_DEPTH20 14

`endif
