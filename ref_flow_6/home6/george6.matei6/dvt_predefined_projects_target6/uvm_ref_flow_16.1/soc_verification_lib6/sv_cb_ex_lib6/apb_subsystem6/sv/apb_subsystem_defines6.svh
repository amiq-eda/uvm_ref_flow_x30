/*-------------------------------------------------------------------------
File6 name   : uart_ctrl_defines6.svh
Title6       : UART6 Controller6 defines6
Project6     :
Created6     :
Description6 : defines6 for the UART6 Controller6 Environment6
Notes6       : 
----------------------------------------------------------------------*/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_DEFINES_SVH6
`define APB_SUBSYSTEM_DEFINES_SVH6

`define AM_SPI0_BASE_ADDRESS6    32'h800000      // SPI06 Base6 Address
`define AM_UART0_BASE_ADDRESS6   32'h810000      // UART06 Base6 Address
`define AM_GPIO0_BASE_ADDRESS6   32'h820000      // GPIO06 Base6 Address
`define AM_UART1_BASE_ADDRESS6   32'h880000      // UART16 Base6 Address
`define AM_SPI0_END_ADDRESS6    32'h80FFFF       // SPI06 END Address
`define AM_UART0_END_ADDRESS6   32'h81FFFF       // UART06 END Address
`define AM_GPIO0_END_ADDRESS6   32'h82FFFF       // GPIO06 END Address
`define AM_UART1_END_ADDRESS6   32'h88FFFF       // UART16 END Address

`endif
