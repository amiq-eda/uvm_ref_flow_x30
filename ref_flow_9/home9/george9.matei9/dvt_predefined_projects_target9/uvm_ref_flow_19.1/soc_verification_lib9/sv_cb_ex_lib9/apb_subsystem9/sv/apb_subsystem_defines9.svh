/*-------------------------------------------------------------------------
File9 name   : uart_ctrl_defines9.svh
Title9       : UART9 Controller9 defines9
Project9     :
Created9     :
Description9 : defines9 for the UART9 Controller9 Environment9
Notes9       : 
----------------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_DEFINES_SVH9
`define APB_SUBSYSTEM_DEFINES_SVH9

`define AM_SPI0_BASE_ADDRESS9    32'h800000      // SPI09 Base9 Address
`define AM_UART0_BASE_ADDRESS9   32'h810000      // UART09 Base9 Address
`define AM_GPIO0_BASE_ADDRESS9   32'h820000      // GPIO09 Base9 Address
`define AM_UART1_BASE_ADDRESS9   32'h880000      // UART19 Base9 Address
`define AM_SPI0_END_ADDRESS9    32'h80FFFF       // SPI09 END Address
`define AM_UART0_END_ADDRESS9   32'h81FFFF       // UART09 END Address
`define AM_GPIO0_END_ADDRESS9   32'h82FFFF       // GPIO09 END Address
`define AM_UART1_END_ADDRESS9   32'h88FFFF       // UART19 END Address

`endif
