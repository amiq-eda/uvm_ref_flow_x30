/*-------------------------------------------------------------------------
File25 name   : uart_ctrl_defines25.svh
Title25       : UART25 Controller25 defines25
Project25     :
Created25     :
Description25 : defines25 for the UART25 Controller25 Environment25
Notes25       : 
----------------------------------------------------------------------*/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_DEFINES_SVH25
`define APB_SUBSYSTEM_DEFINES_SVH25

`define AM_SPI0_BASE_ADDRESS25    32'h800000      // SPI025 Base25 Address
`define AM_UART0_BASE_ADDRESS25   32'h810000      // UART025 Base25 Address
`define AM_GPIO0_BASE_ADDRESS25   32'h820000      // GPIO025 Base25 Address
`define AM_UART1_BASE_ADDRESS25   32'h880000      // UART125 Base25 Address
`define AM_SPI0_END_ADDRESS25    32'h80FFFF       // SPI025 END Address
`define AM_UART0_END_ADDRESS25   32'h81FFFF       // UART025 END Address
`define AM_GPIO0_END_ADDRESS25   32'h82FFFF       // GPIO025 END Address
`define AM_UART1_END_ADDRESS25   32'h88FFFF       // UART125 END Address

`endif
