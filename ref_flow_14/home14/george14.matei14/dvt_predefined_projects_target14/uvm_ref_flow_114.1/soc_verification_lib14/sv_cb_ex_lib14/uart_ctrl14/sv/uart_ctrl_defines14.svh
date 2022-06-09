/*-------------------------------------------------------------------------
File14 name   : uart_ctrl_defines14.svh
Title14       : UART14 Controller14 defines14
Project14     :
Created14     :
Description14 : defines14 for the UART14 Controller14 Environment14
Notes14       : 
----------------------------------------------------------------------*/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------


`ifndef UART_CTRL_DEFINES_SVH14
`define UART_CTRL_DEFINES_SVH14

`define RX_FIFO_REG14 32'h00
`define TX_FIFO_REG14 32'h00
`define INTR_EN14 32'h01
`define INTR_ID14 32'h02
`define FIFO_CTRL14 32'h02
`define LINE_CTRL14 32'h03
`define MODM_CTRL14 32'h04
`define LINE_STAS14 32'h05
`define MODM_STAS14 32'h06

`define DIVD_LATCH114 32'h00
`define DIVD_LATCH214 32'h01

`define UA_TX_FIFO_DEPTH14 14

`endif
