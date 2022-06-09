/*-------------------------------------------------------------------------
File7 name   : uart_ctrl_defines7.svh
Title7       : UART7 Controller7 defines7
Project7     :
Created7     :
Description7 : defines7 for the UART7 Controller7 Environment7
Notes7       : 
----------------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_DEFINES_SVH7
`define APB_SUBSYSTEM_DEFINES_SVH7

`define AM_SPI0_BASE_ADDRESS7    32'h800000      // SPI07 Base7 Address
`define AM_UART0_BASE_ADDRESS7   32'h810000      // UART07 Base7 Address
`define AM_GPIO0_BASE_ADDRESS7   32'h820000      // GPIO07 Base7 Address
`define AM_UART1_BASE_ADDRESS7   32'h880000      // UART17 Base7 Address
`define AM_SPI0_END_ADDRESS7    32'h80FFFF       // SPI07 END Address
`define AM_UART0_END_ADDRESS7   32'h81FFFF       // UART07 END Address
`define AM_GPIO0_END_ADDRESS7   32'h82FFFF       // GPIO07 END Address
`define AM_UART1_END_ADDRESS7   32'h88FFFF       // UART17 END Address

`endif
