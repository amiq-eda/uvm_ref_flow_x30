/*-------------------------------------------------------------------------
File29 name   : uart_ctrl_defines29.svh
Title29       : UART29 Controller29 defines29
Project29     :
Created29     :
Description29 : defines29 for the UART29 Controller29 Environment29
Notes29       : 
----------------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_DEFINES_SVH29
`define APB_SUBSYSTEM_DEFINES_SVH29

`define AM_SPI0_BASE_ADDRESS29    32'h800000      // SPI029 Base29 Address
`define AM_UART0_BASE_ADDRESS29   32'h810000      // UART029 Base29 Address
`define AM_GPIO0_BASE_ADDRESS29   32'h820000      // GPIO029 Base29 Address
`define AM_UART1_BASE_ADDRESS29   32'h880000      // UART129 Base29 Address
`define AM_SPI0_END_ADDRESS29    32'h80FFFF       // SPI029 END Address
`define AM_UART0_END_ADDRESS29   32'h81FFFF       // UART029 END Address
`define AM_GPIO0_END_ADDRESS29   32'h82FFFF       // GPIO029 END Address
`define AM_UART1_END_ADDRESS29   32'h88FFFF       // UART129 END Address

`endif
