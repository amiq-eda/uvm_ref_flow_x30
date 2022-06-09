/*-------------------------------------------------------------------------
File16 name   : uart_ctrl_defines16.svh
Title16       : UART16 Controller16 defines16
Project16     :
Created16     :
Description16 : defines16 for the UART16 Controller16 Environment16
Notes16       : 
----------------------------------------------------------------------*/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_DEFINES_SVH16
`define APB_SUBSYSTEM_DEFINES_SVH16

`define AM_SPI0_BASE_ADDRESS16    32'h800000      // SPI016 Base16 Address
`define AM_UART0_BASE_ADDRESS16   32'h810000      // UART016 Base16 Address
`define AM_GPIO0_BASE_ADDRESS16   32'h820000      // GPIO016 Base16 Address
`define AM_UART1_BASE_ADDRESS16   32'h880000      // UART116 Base16 Address
`define AM_SPI0_END_ADDRESS16    32'h80FFFF       // SPI016 END Address
`define AM_UART0_END_ADDRESS16   32'h81FFFF       // UART016 END Address
`define AM_GPIO0_END_ADDRESS16   32'h82FFFF       // GPIO016 END Address
`define AM_UART1_END_ADDRESS16   32'h88FFFF       // UART116 END Address

`endif
