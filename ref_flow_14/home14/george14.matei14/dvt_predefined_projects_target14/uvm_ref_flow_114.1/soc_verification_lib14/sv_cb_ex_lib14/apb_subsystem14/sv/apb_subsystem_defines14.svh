/*-------------------------------------------------------------------------
File14 name   : uart_ctrl_defines14.svh
Title14       : UART14 Controller14 defines14
Project14     :
Created14     :
Description14 : defines14 for the UART14 Controller14 Environment14
Notes14       : 
----------------------------------------------------------------------*/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_DEFINES_SVH14
`define APB_SUBSYSTEM_DEFINES_SVH14

`define AM_SPI0_BASE_ADDRESS14    32'h800000      // SPI014 Base14 Address
`define AM_UART0_BASE_ADDRESS14   32'h810000      // UART014 Base14 Address
`define AM_GPIO0_BASE_ADDRESS14   32'h820000      // GPIO014 Base14 Address
`define AM_UART1_BASE_ADDRESS14   32'h880000      // UART114 Base14 Address
`define AM_SPI0_END_ADDRESS14    32'h80FFFF       // SPI014 END Address
`define AM_UART0_END_ADDRESS14   32'h81FFFF       // UART014 END Address
`define AM_GPIO0_END_ADDRESS14   32'h82FFFF       // GPIO014 END Address
`define AM_UART1_END_ADDRESS14   32'h88FFFF       // UART114 END Address

`endif
