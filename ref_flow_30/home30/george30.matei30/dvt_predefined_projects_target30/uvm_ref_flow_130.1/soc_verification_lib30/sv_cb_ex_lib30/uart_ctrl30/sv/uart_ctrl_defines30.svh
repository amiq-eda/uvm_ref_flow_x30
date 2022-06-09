/*-------------------------------------------------------------------------
File30 name   : uart_ctrl_defines30.svh
Title30       : UART30 Controller30 defines30
Project30     :
Created30     :
Description30 : defines30 for the UART30 Controller30 Environment30
Notes30       : 
----------------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


`ifndef UART_CTRL_DEFINES_SVH30
`define UART_CTRL_DEFINES_SVH30

`define RX_FIFO_REG30 32'h00
`define TX_FIFO_REG30 32'h00
`define INTR_EN30 32'h01
`define INTR_ID30 32'h02
`define FIFO_CTRL30 32'h02
`define LINE_CTRL30 32'h03
`define MODM_CTRL30 32'h04
`define LINE_STAS30 32'h05
`define MODM_STAS30 32'h06

`define DIVD_LATCH130 32'h00
`define DIVD_LATCH230 32'h01

`define UA_TX_FIFO_DEPTH30 14

`endif
