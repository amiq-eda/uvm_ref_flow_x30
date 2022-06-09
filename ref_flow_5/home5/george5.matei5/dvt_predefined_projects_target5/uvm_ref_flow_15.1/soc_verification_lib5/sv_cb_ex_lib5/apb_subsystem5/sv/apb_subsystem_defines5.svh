/*-------------------------------------------------------------------------
File5 name   : uart_ctrl_defines5.svh
Title5       : UART5 Controller5 defines5
Project5     :
Created5     :
Description5 : defines5 for the UART5 Controller5 Environment5
Notes5       : 
----------------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_DEFINES_SVH5
`define APB_SUBSYSTEM_DEFINES_SVH5

`define AM_SPI0_BASE_ADDRESS5    32'h800000      // SPI05 Base5 Address
`define AM_UART0_BASE_ADDRESS5   32'h810000      // UART05 Base5 Address
`define AM_GPIO0_BASE_ADDRESS5   32'h820000      // GPIO05 Base5 Address
`define AM_UART1_BASE_ADDRESS5   32'h880000      // UART15 Base5 Address
`define AM_SPI0_END_ADDRESS5    32'h80FFFF       // SPI05 END Address
`define AM_UART0_END_ADDRESS5   32'h81FFFF       // UART05 END Address
`define AM_GPIO0_END_ADDRESS5   32'h82FFFF       // GPIO05 END Address
`define AM_UART1_END_ADDRESS5   32'h88FFFF       // UART15 END Address

`endif
