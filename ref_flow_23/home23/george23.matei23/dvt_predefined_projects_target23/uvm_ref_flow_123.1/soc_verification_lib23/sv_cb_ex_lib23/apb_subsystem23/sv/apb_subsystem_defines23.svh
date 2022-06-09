/*-------------------------------------------------------------------------
File23 name   : uart_ctrl_defines23.svh
Title23       : UART23 Controller23 defines23
Project23     :
Created23     :
Description23 : defines23 for the UART23 Controller23 Environment23
Notes23       : 
----------------------------------------------------------------------*/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_DEFINES_SVH23
`define APB_SUBSYSTEM_DEFINES_SVH23

`define AM_SPI0_BASE_ADDRESS23    32'h800000      // SPI023 Base23 Address
`define AM_UART0_BASE_ADDRESS23   32'h810000      // UART023 Base23 Address
`define AM_GPIO0_BASE_ADDRESS23   32'h820000      // GPIO023 Base23 Address
`define AM_UART1_BASE_ADDRESS23   32'h880000      // UART123 Base23 Address
`define AM_SPI0_END_ADDRESS23    32'h80FFFF       // SPI023 END Address
`define AM_UART0_END_ADDRESS23   32'h81FFFF       // UART023 END Address
`define AM_GPIO0_END_ADDRESS23   32'h82FFFF       // GPIO023 END Address
`define AM_UART1_END_ADDRESS23   32'h88FFFF       // UART123 END Address

`endif
