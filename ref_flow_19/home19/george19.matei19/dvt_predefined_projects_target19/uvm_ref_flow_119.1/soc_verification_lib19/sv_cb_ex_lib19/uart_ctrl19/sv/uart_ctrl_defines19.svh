/*-------------------------------------------------------------------------
File19 name   : uart_ctrl_defines19.svh
Title19       : UART19 Controller19 defines19
Project19     :
Created19     :
Description19 : defines19 for the UART19 Controller19 Environment19
Notes19       : 
----------------------------------------------------------------------*/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------


`ifndef UART_CTRL_DEFINES_SVH19
`define UART_CTRL_DEFINES_SVH19

`define RX_FIFO_REG19 32'h00
`define TX_FIFO_REG19 32'h00
`define INTR_EN19 32'h01
`define INTR_ID19 32'h02
`define FIFO_CTRL19 32'h02
`define LINE_CTRL19 32'h03
`define MODM_CTRL19 32'h04
`define LINE_STAS19 32'h05
`define MODM_STAS19 32'h06

`define DIVD_LATCH119 32'h00
`define DIVD_LATCH219 32'h01

`define UA_TX_FIFO_DEPTH19 14

`endif
