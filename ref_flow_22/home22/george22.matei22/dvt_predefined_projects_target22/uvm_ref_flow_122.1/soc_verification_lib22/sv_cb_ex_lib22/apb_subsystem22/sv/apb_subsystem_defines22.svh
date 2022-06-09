/*-------------------------------------------------------------------------
File22 name   : uart_ctrl_defines22.svh
Title22       : UART22 Controller22 defines22
Project22     :
Created22     :
Description22 : defines22 for the UART22 Controller22 Environment22
Notes22       : 
----------------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_DEFINES_SVH22
`define APB_SUBSYSTEM_DEFINES_SVH22

`define AM_SPI0_BASE_ADDRESS22    32'h800000      // SPI022 Base22 Address
`define AM_UART0_BASE_ADDRESS22   32'h810000      // UART022 Base22 Address
`define AM_GPIO0_BASE_ADDRESS22   32'h820000      // GPIO022 Base22 Address
`define AM_UART1_BASE_ADDRESS22   32'h880000      // UART122 Base22 Address
`define AM_SPI0_END_ADDRESS22    32'h80FFFF       // SPI022 END Address
`define AM_UART0_END_ADDRESS22   32'h81FFFF       // UART022 END Address
`define AM_GPIO0_END_ADDRESS22   32'h82FFFF       // GPIO022 END Address
`define AM_UART1_END_ADDRESS22   32'h88FFFF       // UART122 END Address

`endif
