/*-------------------------------------------------------------------------
File20 name   : uart_ctrl_defines20.svh
Title20       : UART20 Controller20 defines20
Project20     :
Created20     :
Description20 : defines20 for the UART20 Controller20 Environment20
Notes20       : 
----------------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_DEFINES_SVH20
`define APB_SUBSYSTEM_DEFINES_SVH20

`define AM_SPI0_BASE_ADDRESS20    32'h800000      // SPI020 Base20 Address
`define AM_UART0_BASE_ADDRESS20   32'h810000      // UART020 Base20 Address
`define AM_GPIO0_BASE_ADDRESS20   32'h820000      // GPIO020 Base20 Address
`define AM_UART1_BASE_ADDRESS20   32'h880000      // UART120 Base20 Address
`define AM_SPI0_END_ADDRESS20    32'h80FFFF       // SPI020 END Address
`define AM_UART0_END_ADDRESS20   32'h81FFFF       // UART020 END Address
`define AM_GPIO0_END_ADDRESS20   32'h82FFFF       // GPIO020 END Address
`define AM_UART1_END_ADDRESS20   32'h88FFFF       // UART120 END Address

`endif
