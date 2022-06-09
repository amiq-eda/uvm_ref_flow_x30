/*-------------------------------------------------------------------------
File17 name   : uart_ctrl_defines17.svh
Title17       : UART17 Controller17 defines17
Project17     :
Created17     :
Description17 : defines17 for the UART17 Controller17 Environment17
Notes17       : 
----------------------------------------------------------------------*/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_DEFINES_SVH17
`define APB_SUBSYSTEM_DEFINES_SVH17

`define AM_SPI0_BASE_ADDRESS17    32'h800000      // SPI017 Base17 Address
`define AM_UART0_BASE_ADDRESS17   32'h810000      // UART017 Base17 Address
`define AM_GPIO0_BASE_ADDRESS17   32'h820000      // GPIO017 Base17 Address
`define AM_UART1_BASE_ADDRESS17   32'h880000      // UART117 Base17 Address
`define AM_SPI0_END_ADDRESS17    32'h80FFFF       // SPI017 END Address
`define AM_UART0_END_ADDRESS17   32'h81FFFF       // UART017 END Address
`define AM_GPIO0_END_ADDRESS17   32'h82FFFF       // GPIO017 END Address
`define AM_UART1_END_ADDRESS17   32'h88FFFF       // UART117 END Address

`endif
