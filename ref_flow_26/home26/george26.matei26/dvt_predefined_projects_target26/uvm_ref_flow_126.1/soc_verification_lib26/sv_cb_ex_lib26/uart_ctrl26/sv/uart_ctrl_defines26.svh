/*-------------------------------------------------------------------------
File26 name   : uart_ctrl_defines26.svh
Title26       : UART26 Controller26 defines26
Project26     :
Created26     :
Description26 : defines26 for the UART26 Controller26 Environment26
Notes26       : 
----------------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


`ifndef UART_CTRL_DEFINES_SVH26
`define UART_CTRL_DEFINES_SVH26

`define RX_FIFO_REG26 32'h00
`define TX_FIFO_REG26 32'h00
`define INTR_EN26 32'h01
`define INTR_ID26 32'h02
`define FIFO_CTRL26 32'h02
`define LINE_CTRL26 32'h03
`define MODM_CTRL26 32'h04
`define LINE_STAS26 32'h05
`define MODM_STAS26 32'h06

`define DIVD_LATCH126 32'h00
`define DIVD_LATCH226 32'h01

`define UA_TX_FIFO_DEPTH26 14

`endif
