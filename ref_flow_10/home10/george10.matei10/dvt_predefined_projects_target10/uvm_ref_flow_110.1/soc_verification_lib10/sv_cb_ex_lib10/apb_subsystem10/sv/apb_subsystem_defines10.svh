/*-------------------------------------------------------------------------
File10 name   : uart_ctrl_defines10.svh
Title10       : UART10 Controller10 defines10
Project10     :
Created10     :
Description10 : defines10 for the UART10 Controller10 Environment10
Notes10       : 
----------------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_DEFINES_SVH10
`define APB_SUBSYSTEM_DEFINES_SVH10

`define AM_SPI0_BASE_ADDRESS10    32'h800000      // SPI010 Base10 Address
`define AM_UART0_BASE_ADDRESS10   32'h810000      // UART010 Base10 Address
`define AM_GPIO0_BASE_ADDRESS10   32'h820000      // GPIO010 Base10 Address
`define AM_UART1_BASE_ADDRESS10   32'h880000      // UART110 Base10 Address
`define AM_SPI0_END_ADDRESS10    32'h80FFFF       // SPI010 END Address
`define AM_UART0_END_ADDRESS10   32'h81FFFF       // UART010 END Address
`define AM_GPIO0_END_ADDRESS10   32'h82FFFF       // GPIO010 END Address
`define AM_UART1_END_ADDRESS10   32'h88FFFF       // UART110 END Address

`endif
