/*-------------------------------------------------------------------------
File19 name   : uart_ctrl_defines19.svh
Title19       : UART19 Controller19 defines19
Project19     :
Created19     :
Description19 : defines19 for the UART19 Controller19 Environment19
Notes19       : 
----------------------------------------------------------------------*/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_DEFINES_SVH19
`define APB_SUBSYSTEM_DEFINES_SVH19

`define AM_SPI0_BASE_ADDRESS19    32'h800000      // SPI019 Base19 Address
`define AM_UART0_BASE_ADDRESS19   32'h810000      // UART019 Base19 Address
`define AM_GPIO0_BASE_ADDRESS19   32'h820000      // GPIO019 Base19 Address
`define AM_UART1_BASE_ADDRESS19   32'h880000      // UART119 Base19 Address
`define AM_SPI0_END_ADDRESS19    32'h80FFFF       // SPI019 END Address
`define AM_UART0_END_ADDRESS19   32'h81FFFF       // UART019 END Address
`define AM_GPIO0_END_ADDRESS19   32'h82FFFF       // GPIO019 END Address
`define AM_UART1_END_ADDRESS19   32'h88FFFF       // UART119 END Address

`endif
