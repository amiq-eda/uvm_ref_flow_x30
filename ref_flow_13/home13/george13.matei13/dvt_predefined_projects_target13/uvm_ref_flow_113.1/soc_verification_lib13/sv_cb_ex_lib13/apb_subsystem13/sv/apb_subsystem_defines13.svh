/*-------------------------------------------------------------------------
File13 name   : uart_ctrl_defines13.svh
Title13       : UART13 Controller13 defines13
Project13     :
Created13     :
Description13 : defines13 for the UART13 Controller13 Environment13
Notes13       : 
----------------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_DEFINES_SVH13
`define APB_SUBSYSTEM_DEFINES_SVH13

`define AM_SPI0_BASE_ADDRESS13    32'h800000      // SPI013 Base13 Address
`define AM_UART0_BASE_ADDRESS13   32'h810000      // UART013 Base13 Address
`define AM_GPIO0_BASE_ADDRESS13   32'h820000      // GPIO013 Base13 Address
`define AM_UART1_BASE_ADDRESS13   32'h880000      // UART113 Base13 Address
`define AM_SPI0_END_ADDRESS13    32'h80FFFF       // SPI013 END Address
`define AM_UART0_END_ADDRESS13   32'h81FFFF       // UART013 END Address
`define AM_GPIO0_END_ADDRESS13   32'h82FFFF       // GPIO013 END Address
`define AM_UART1_END_ADDRESS13   32'h88FFFF       // UART113 END Address

`endif
