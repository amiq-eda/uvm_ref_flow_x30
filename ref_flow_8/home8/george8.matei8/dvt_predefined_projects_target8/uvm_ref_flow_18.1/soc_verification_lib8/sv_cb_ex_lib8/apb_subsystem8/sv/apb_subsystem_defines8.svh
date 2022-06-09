/*-------------------------------------------------------------------------
File8 name   : uart_ctrl_defines8.svh
Title8       : UART8 Controller8 defines8
Project8     :
Created8     :
Description8 : defines8 for the UART8 Controller8 Environment8
Notes8       : 
----------------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_DEFINES_SVH8
`define APB_SUBSYSTEM_DEFINES_SVH8

`define AM_SPI0_BASE_ADDRESS8    32'h800000      // SPI08 Base8 Address
`define AM_UART0_BASE_ADDRESS8   32'h810000      // UART08 Base8 Address
`define AM_GPIO0_BASE_ADDRESS8   32'h820000      // GPIO08 Base8 Address
`define AM_UART1_BASE_ADDRESS8   32'h880000      // UART18 Base8 Address
`define AM_SPI0_END_ADDRESS8    32'h80FFFF       // SPI08 END Address
`define AM_UART0_END_ADDRESS8   32'h81FFFF       // UART08 END Address
`define AM_GPIO0_END_ADDRESS8   32'h82FFFF       // GPIO08 END Address
`define AM_UART1_END_ADDRESS8   32'h88FFFF       // UART18 END Address

`endif
