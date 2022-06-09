/*-------------------------------------------------------------------------
File28 name   : uart_ctrl_defines28.svh
Title28       : UART28 Controller28 defines28
Project28     :
Created28     :
Description28 : defines28 for the UART28 Controller28 Environment28
Notes28       : 
----------------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_DEFINES_SVH28
`define APB_SUBSYSTEM_DEFINES_SVH28

`define AM_SPI0_BASE_ADDRESS28    32'h800000      // SPI028 Base28 Address
`define AM_UART0_BASE_ADDRESS28   32'h810000      // UART028 Base28 Address
`define AM_GPIO0_BASE_ADDRESS28   32'h820000      // GPIO028 Base28 Address
`define AM_UART1_BASE_ADDRESS28   32'h880000      // UART128 Base28 Address
`define AM_SPI0_END_ADDRESS28    32'h80FFFF       // SPI028 END Address
`define AM_UART0_END_ADDRESS28   32'h81FFFF       // UART028 END Address
`define AM_GPIO0_END_ADDRESS28   32'h82FFFF       // GPIO028 END Address
`define AM_UART1_END_ADDRESS28   32'h88FFFF       // UART128 END Address

`endif
