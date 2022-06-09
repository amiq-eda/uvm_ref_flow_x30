/*-------------------------------------------------------------------------
File30 name   : uart_ctrl_defines30.svh
Title30       : UART30 Controller30 defines30
Project30     :
Created30     :
Description30 : defines30 for the UART30 Controller30 Environment30
Notes30       : 
----------------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_DEFINES_SVH30
`define APB_SUBSYSTEM_DEFINES_SVH30

`define AM_SPI0_BASE_ADDRESS30    32'h800000      // SPI030 Base30 Address
`define AM_UART0_BASE_ADDRESS30   32'h810000      // UART030 Base30 Address
`define AM_GPIO0_BASE_ADDRESS30   32'h820000      // GPIO030 Base30 Address
`define AM_UART1_BASE_ADDRESS30   32'h880000      // UART130 Base30 Address
`define AM_SPI0_END_ADDRESS30    32'h80FFFF       // SPI030 END Address
`define AM_UART0_END_ADDRESS30   32'h81FFFF       // UART030 END Address
`define AM_GPIO0_END_ADDRESS30   32'h82FFFF       // GPIO030 END Address
`define AM_UART1_END_ADDRESS30   32'h88FFFF       // UART130 END Address

`endif
