/*-------------------------------------------------------------------------
File2 name   : uart_ctrl_defines2.svh
Title2       : UART2 Controller2 defines2
Project2     :
Created2     :
Description2 : defines2 for the UART2 Controller2 Environment2
Notes2       : 
----------------------------------------------------------------------*/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------


`ifndef UART_CTRL_DEFINES_SVH2
`define UART_CTRL_DEFINES_SVH2

`define RX_FIFO_REG2 32'h00
`define TX_FIFO_REG2 32'h00
`define INTR_EN2 32'h01
`define INTR_ID2 32'h02
`define FIFO_CTRL2 32'h02
`define LINE_CTRL2 32'h03
`define MODM_CTRL2 32'h04
`define LINE_STAS2 32'h05
`define MODM_STAS2 32'h06

`define DIVD_LATCH12 32'h00
`define DIVD_LATCH22 32'h01

`define UA_TX_FIFO_DEPTH2 14

`endif
