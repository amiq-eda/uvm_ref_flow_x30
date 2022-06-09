/*-------------------------------------------------------------------------
File4 name   : uart_ctrl_defines4.svh
Title4       : UART4 Controller4 defines4
Project4     :
Created4     :
Description4 : defines4 for the UART4 Controller4 Environment4
Notes4       : 
----------------------------------------------------------------------*/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_DEFINES_SVH4
`define APB_SUBSYSTEM_DEFINES_SVH4

`define AM_SPI0_BASE_ADDRESS4    32'h800000      // SPI04 Base4 Address
`define AM_UART0_BASE_ADDRESS4   32'h810000      // UART04 Base4 Address
`define AM_GPIO0_BASE_ADDRESS4   32'h820000      // GPIO04 Base4 Address
`define AM_UART1_BASE_ADDRESS4   32'h880000      // UART14 Base4 Address
`define AM_SPI0_END_ADDRESS4    32'h80FFFF       // SPI04 END Address
`define AM_UART0_END_ADDRESS4   32'h81FFFF       // UART04 END Address
`define AM_GPIO0_END_ADDRESS4   32'h82FFFF       // GPIO04 END Address
`define AM_UART1_END_ADDRESS4   32'h88FFFF       // UART14 END Address

`endif
