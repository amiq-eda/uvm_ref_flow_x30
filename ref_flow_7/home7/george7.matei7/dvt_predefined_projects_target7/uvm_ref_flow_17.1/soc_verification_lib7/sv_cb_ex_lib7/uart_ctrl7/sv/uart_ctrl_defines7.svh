/*-------------------------------------------------------------------------
File7 name   : uart_ctrl_defines7.svh
Title7       : UART7 Controller7 defines7
Project7     :
Created7     :
Description7 : defines7 for the UART7 Controller7 Environment7
Notes7       : 
----------------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------


`ifndef UART_CTRL_DEFINES_SVH7
`define UART_CTRL_DEFINES_SVH7

`define RX_FIFO_REG7 32'h00
`define TX_FIFO_REG7 32'h00
`define INTR_EN7 32'h01
`define INTR_ID7 32'h02
`define FIFO_CTRL7 32'h02
`define LINE_CTRL7 32'h03
`define MODM_CTRL7 32'h04
`define LINE_STAS7 32'h05
`define MODM_STAS7 32'h06

`define DIVD_LATCH17 32'h00
`define DIVD_LATCH27 32'h01

`define UA_TX_FIFO_DEPTH7 14

`endif
