/*-------------------------------------------------------------------------
File3 name   : uart_ctrl_defines3.svh
Title3       : UART3 Controller3 defines3
Project3     :
Created3     :
Description3 : defines3 for the UART3 Controller3 Environment3
Notes3       : 
----------------------------------------------------------------------*/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_DEFINES_SVH3
`define APB_SUBSYSTEM_DEFINES_SVH3

`define AM_SPI0_BASE_ADDRESS3    32'h800000      // SPI03 Base3 Address
`define AM_UART0_BASE_ADDRESS3   32'h810000      // UART03 Base3 Address
`define AM_GPIO0_BASE_ADDRESS3   32'h820000      // GPIO03 Base3 Address
`define AM_UART1_BASE_ADDRESS3   32'h880000      // UART13 Base3 Address
`define AM_SPI0_END_ADDRESS3    32'h80FFFF       // SPI03 END Address
`define AM_UART0_END_ADDRESS3   32'h81FFFF       // UART03 END Address
`define AM_GPIO0_END_ADDRESS3   32'h82FFFF       // GPIO03 END Address
`define AM_UART1_END_ADDRESS3   32'h88FFFF       // UART13 END Address

`endif
