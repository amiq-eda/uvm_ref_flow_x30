/*-------------------------------------------------------------------------
File26 name   : uart_ctrl_defines26.svh
Title26       : UART26 Controller26 defines26
Project26     :
Created26     :
Description26 : defines26 for the UART26 Controller26 Environment26
Notes26       : 
----------------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_DEFINES_SVH26
`define APB_SUBSYSTEM_DEFINES_SVH26

`define AM_SPI0_BASE_ADDRESS26    32'h800000      // SPI026 Base26 Address
`define AM_UART0_BASE_ADDRESS26   32'h810000      // UART026 Base26 Address
`define AM_GPIO0_BASE_ADDRESS26   32'h820000      // GPIO026 Base26 Address
`define AM_UART1_BASE_ADDRESS26   32'h880000      // UART126 Base26 Address
`define AM_SPI0_END_ADDRESS26    32'h80FFFF       // SPI026 END Address
`define AM_UART0_END_ADDRESS26   32'h81FFFF       // UART026 END Address
`define AM_GPIO0_END_ADDRESS26   32'h82FFFF       // GPIO026 END Address
`define AM_UART1_END_ADDRESS26   32'h88FFFF       // UART126 END Address

`endif
