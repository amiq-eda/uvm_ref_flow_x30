/*-------------------------------------------------------------------------
File1 name   : uart_ctrl_defines1.svh
Title1       : UART1 Controller1 defines1
Project1     :
Created1     :
Description1 : defines1 for the UART1 Controller1 Environment1
Notes1       : 
----------------------------------------------------------------------*/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------


`ifndef UART_CTRL_DEFINES_SVH1
`define UART_CTRL_DEFINES_SVH1

`define RX_FIFO_REG1 32'h00
`define TX_FIFO_REG1 32'h00
`define INTR_EN1 32'h01
`define INTR_ID1 32'h02
`define FIFO_CTRL1 32'h02
`define LINE_CTRL1 32'h03
`define MODM_CTRL1 32'h04
`define LINE_STAS1 32'h05
`define MODM_STAS1 32'h06

`define DIVD_LATCH11 32'h00
`define DIVD_LATCH21 32'h01

`define UA_TX_FIFO_DEPTH1 14

`endif
