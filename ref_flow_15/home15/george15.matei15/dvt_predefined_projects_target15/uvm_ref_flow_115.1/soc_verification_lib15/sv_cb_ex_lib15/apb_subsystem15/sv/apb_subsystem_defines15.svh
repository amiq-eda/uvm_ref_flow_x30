/*-------------------------------------------------------------------------
File15 name   : uart_ctrl_defines15.svh
Title15       : UART15 Controller15 defines15
Project15     :
Created15     :
Description15 : defines15 for the UART15 Controller15 Environment15
Notes15       : 
----------------------------------------------------------------------*/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_DEFINES_SVH15
`define APB_SUBSYSTEM_DEFINES_SVH15

`define AM_SPI0_BASE_ADDRESS15    32'h800000      // SPI015 Base15 Address
`define AM_UART0_BASE_ADDRESS15   32'h810000      // UART015 Base15 Address
`define AM_GPIO0_BASE_ADDRESS15   32'h820000      // GPIO015 Base15 Address
`define AM_UART1_BASE_ADDRESS15   32'h880000      // UART115 Base15 Address
`define AM_SPI0_END_ADDRESS15    32'h80FFFF       // SPI015 END Address
`define AM_UART0_END_ADDRESS15   32'h81FFFF       // UART015 END Address
`define AM_GPIO0_END_ADDRESS15   32'h82FFFF       // GPIO015 END Address
`define AM_UART1_END_ADDRESS15   32'h88FFFF       // UART115 END Address

`endif
