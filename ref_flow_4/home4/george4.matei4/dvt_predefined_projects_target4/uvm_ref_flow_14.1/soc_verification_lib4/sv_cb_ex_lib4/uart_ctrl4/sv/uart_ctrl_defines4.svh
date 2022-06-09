/*-------------------------------------------------------------------------
File4 name   : uart_ctrl_defines4.svh
Title4       : UART4 Controller4 defines4
Project4     :
Created4     :
Description4 : defines4 for the UART4 Controller4 Environment4
Notes4       : 
----------------------------------------------------------------------*/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------


`ifndef UART_CTRL_DEFINES_SVH4
`define UART_CTRL_DEFINES_SVH4

`define RX_FIFO_REG4 32'h00
`define TX_FIFO_REG4 32'h00
`define INTR_EN4 32'h01
`define INTR_ID4 32'h02
`define FIFO_CTRL4 32'h02
`define LINE_CTRL4 32'h03
`define MODM_CTRL4 32'h04
`define LINE_STAS4 32'h05
`define MODM_STAS4 32'h06

`define DIVD_LATCH14 32'h00
`define DIVD_LATCH24 32'h01

`define UA_TX_FIFO_DEPTH4 14

`endif
