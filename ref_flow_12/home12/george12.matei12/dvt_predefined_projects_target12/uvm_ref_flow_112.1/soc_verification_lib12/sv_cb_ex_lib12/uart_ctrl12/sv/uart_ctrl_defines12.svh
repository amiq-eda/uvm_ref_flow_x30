/*-------------------------------------------------------------------------
File12 name   : uart_ctrl_defines12.svh
Title12       : UART12 Controller12 defines12
Project12     :
Created12     :
Description12 : defines12 for the UART12 Controller12 Environment12
Notes12       : 
----------------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------


`ifndef UART_CTRL_DEFINES_SVH12
`define UART_CTRL_DEFINES_SVH12

`define RX_FIFO_REG12 32'h00
`define TX_FIFO_REG12 32'h00
`define INTR_EN12 32'h01
`define INTR_ID12 32'h02
`define FIFO_CTRL12 32'h02
`define LINE_CTRL12 32'h03
`define MODM_CTRL12 32'h04
`define LINE_STAS12 32'h05
`define MODM_STAS12 32'h06

`define DIVD_LATCH112 32'h00
`define DIVD_LATCH212 32'h01

`define UA_TX_FIFO_DEPTH12 14

`endif
