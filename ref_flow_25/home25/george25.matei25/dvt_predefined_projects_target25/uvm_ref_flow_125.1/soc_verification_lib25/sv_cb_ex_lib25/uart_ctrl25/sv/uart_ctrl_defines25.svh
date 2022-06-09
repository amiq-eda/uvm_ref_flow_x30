/*-------------------------------------------------------------------------
File25 name   : uart_ctrl_defines25.svh
Title25       : UART25 Controller25 defines25
Project25     :
Created25     :
Description25 : defines25 for the UART25 Controller25 Environment25
Notes25       : 
----------------------------------------------------------------------*/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------


`ifndef UART_CTRL_DEFINES_SVH25
`define UART_CTRL_DEFINES_SVH25

`define RX_FIFO_REG25 32'h00
`define TX_FIFO_REG25 32'h00
`define INTR_EN25 32'h01
`define INTR_ID25 32'h02
`define FIFO_CTRL25 32'h02
`define LINE_CTRL25 32'h03
`define MODM_CTRL25 32'h04
`define LINE_STAS25 32'h05
`define MODM_STAS25 32'h06

`define DIVD_LATCH125 32'h00
`define DIVD_LATCH225 32'h01

`define UA_TX_FIFO_DEPTH25 14

`endif
