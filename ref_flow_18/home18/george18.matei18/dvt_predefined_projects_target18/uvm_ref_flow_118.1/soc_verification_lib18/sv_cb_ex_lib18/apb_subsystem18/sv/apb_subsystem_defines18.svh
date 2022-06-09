/*-------------------------------------------------------------------------
File18 name   : uart_ctrl_defines18.svh
Title18       : UART18 Controller18 defines18
Project18     :
Created18     :
Description18 : defines18 for the UART18 Controller18 Environment18
Notes18       : 
----------------------------------------------------------------------*/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_DEFINES_SVH18
`define APB_SUBSYSTEM_DEFINES_SVH18

`define AM_SPI0_BASE_ADDRESS18    32'h800000      // SPI018 Base18 Address
`define AM_UART0_BASE_ADDRESS18   32'h810000      // UART018 Base18 Address
`define AM_GPIO0_BASE_ADDRESS18   32'h820000      // GPIO018 Base18 Address
`define AM_UART1_BASE_ADDRESS18   32'h880000      // UART118 Base18 Address
`define AM_SPI0_END_ADDRESS18    32'h80FFFF       // SPI018 END Address
`define AM_UART0_END_ADDRESS18   32'h81FFFF       // UART018 END Address
`define AM_GPIO0_END_ADDRESS18   32'h82FFFF       // GPIO018 END Address
`define AM_UART1_END_ADDRESS18   32'h88FFFF       // UART118 END Address

`endif
