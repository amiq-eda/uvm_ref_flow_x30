/*-------------------------------------------------------------------------
File21 name   : uart_ctrl_defines21.svh
Title21       : UART21 Controller21 defines21
Project21     :
Created21     :
Description21 : defines21 for the UART21 Controller21 Environment21
Notes21       : 
----------------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_DEFINES_SVH21
`define APB_SUBSYSTEM_DEFINES_SVH21

`define AM_SPI0_BASE_ADDRESS21    32'h800000      // SPI021 Base21 Address
`define AM_UART0_BASE_ADDRESS21   32'h810000      // UART021 Base21 Address
`define AM_GPIO0_BASE_ADDRESS21   32'h820000      // GPIO021 Base21 Address
`define AM_UART1_BASE_ADDRESS21   32'h880000      // UART121 Base21 Address
`define AM_SPI0_END_ADDRESS21    32'h80FFFF       // SPI021 END Address
`define AM_UART0_END_ADDRESS21   32'h81FFFF       // UART021 END Address
`define AM_GPIO0_END_ADDRESS21   32'h82FFFF       // GPIO021 END Address
`define AM_UART1_END_ADDRESS21   32'h88FFFF       // UART121 END Address

`endif
