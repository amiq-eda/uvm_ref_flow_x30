/*-------------------------------------------------------------------------
File12 name   : uart_ctrl_defines12.svh
Title12       : UART12 Controller12 defines12
Project12     :
Created12     :
Description12 : defines12 for the UART12 Controller12 Environment12
Notes12       : 
----------------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_DEFINES_SVH12
`define APB_SUBSYSTEM_DEFINES_SVH12

`define AM_SPI0_BASE_ADDRESS12    32'h800000      // SPI012 Base12 Address
`define AM_UART0_BASE_ADDRESS12   32'h810000      // UART012 Base12 Address
`define AM_GPIO0_BASE_ADDRESS12   32'h820000      // GPIO012 Base12 Address
`define AM_UART1_BASE_ADDRESS12   32'h880000      // UART112 Base12 Address
`define AM_SPI0_END_ADDRESS12    32'h80FFFF       // SPI012 END Address
`define AM_UART0_END_ADDRESS12   32'h81FFFF       // UART012 END Address
`define AM_GPIO0_END_ADDRESS12   32'h82FFFF       // GPIO012 END Address
`define AM_UART1_END_ADDRESS12   32'h88FFFF       // UART112 END Address

`endif
