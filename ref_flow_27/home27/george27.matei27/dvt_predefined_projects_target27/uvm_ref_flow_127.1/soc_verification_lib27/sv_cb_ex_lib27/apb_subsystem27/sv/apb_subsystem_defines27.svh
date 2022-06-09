/*-------------------------------------------------------------------------
File27 name   : uart_ctrl_defines27.svh
Title27       : UART27 Controller27 defines27
Project27     :
Created27     :
Description27 : defines27 for the UART27 Controller27 Environment27
Notes27       : 
----------------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_DEFINES_SVH27
`define APB_SUBSYSTEM_DEFINES_SVH27

`define AM_SPI0_BASE_ADDRESS27    32'h800000      // SPI027 Base27 Address
`define AM_UART0_BASE_ADDRESS27   32'h810000      // UART027 Base27 Address
`define AM_GPIO0_BASE_ADDRESS27   32'h820000      // GPIO027 Base27 Address
`define AM_UART1_BASE_ADDRESS27   32'h880000      // UART127 Base27 Address
`define AM_SPI0_END_ADDRESS27    32'h80FFFF       // SPI027 END Address
`define AM_UART0_END_ADDRESS27   32'h81FFFF       // UART027 END Address
`define AM_GPIO0_END_ADDRESS27   32'h82FFFF       // GPIO027 END Address
`define AM_UART1_END_ADDRESS27   32'h88FFFF       // UART127 END Address

`endif
