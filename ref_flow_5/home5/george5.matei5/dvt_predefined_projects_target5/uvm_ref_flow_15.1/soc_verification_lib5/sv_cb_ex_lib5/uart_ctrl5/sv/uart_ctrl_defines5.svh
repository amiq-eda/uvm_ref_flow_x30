/*-------------------------------------------------------------------------
File5 name   : uart_ctrl_defines5.svh
Title5       : UART5 Controller5 defines5
Project5     :
Created5     :
Description5 : defines5 for the UART5 Controller5 Environment5
Notes5       : 
----------------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------


`ifndef UART_CTRL_DEFINES_SVH5
`define UART_CTRL_DEFINES_SVH5

`define RX_FIFO_REG5 32'h00
`define TX_FIFO_REG5 32'h00
`define INTR_EN5 32'h01
`define INTR_ID5 32'h02
`define FIFO_CTRL5 32'h02
`define LINE_CTRL5 32'h03
`define MODM_CTRL5 32'h04
`define LINE_STAS5 32'h05
`define MODM_STAS5 32'h06

`define DIVD_LATCH15 32'h00
`define DIVD_LATCH25 32'h01

`define UA_TX_FIFO_DEPTH5 14

`endif
