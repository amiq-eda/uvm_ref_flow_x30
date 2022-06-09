/*-------------------------------------------------------------------------
File24 name   : uart_ctrl_defines24.svh
Title24       : UART24 Controller24 defines24
Project24     :
Created24     :
Description24 : defines24 for the UART24 Controller24 Environment24
Notes24       : 
----------------------------------------------------------------------*/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_DEFINES_SVH24
`define APB_SUBSYSTEM_DEFINES_SVH24

`define AM_SPI0_BASE_ADDRESS24    32'h800000      // SPI024 Base24 Address
`define AM_UART0_BASE_ADDRESS24   32'h810000      // UART024 Base24 Address
`define AM_GPIO0_BASE_ADDRESS24   32'h820000      // GPIO024 Base24 Address
`define AM_UART1_BASE_ADDRESS24   32'h880000      // UART124 Base24 Address
`define AM_SPI0_END_ADDRESS24    32'h80FFFF       // SPI024 END Address
`define AM_UART0_END_ADDRESS24   32'h81FFFF       // UART024 END Address
`define AM_GPIO0_END_ADDRESS24   32'h82FFFF       // GPIO024 END Address
`define AM_UART1_END_ADDRESS24   32'h88FFFF       // UART124 END Address

`endif
