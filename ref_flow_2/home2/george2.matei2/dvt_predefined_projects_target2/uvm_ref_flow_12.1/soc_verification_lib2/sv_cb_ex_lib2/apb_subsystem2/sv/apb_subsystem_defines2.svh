/*-------------------------------------------------------------------------
File2 name   : uart_ctrl_defines2.svh
Title2       : UART2 Controller2 defines2
Project2     :
Created2     :
Description2 : defines2 for the UART2 Controller2 Environment2
Notes2       : 
----------------------------------------------------------------------*/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_DEFINES_SVH2
`define APB_SUBSYSTEM_DEFINES_SVH2

`define AM_SPI0_BASE_ADDRESS2    32'h800000      // SPI02 Base2 Address
`define AM_UART0_BASE_ADDRESS2   32'h810000      // UART02 Base2 Address
`define AM_GPIO0_BASE_ADDRESS2   32'h820000      // GPIO02 Base2 Address
`define AM_UART1_BASE_ADDRESS2   32'h880000      // UART12 Base2 Address
`define AM_SPI0_END_ADDRESS2    32'h80FFFF       // SPI02 END Address
`define AM_UART0_END_ADDRESS2   32'h81FFFF       // UART02 END Address
`define AM_GPIO0_END_ADDRESS2   32'h82FFFF       // GPIO02 END Address
`define AM_UART1_END_ADDRESS2   32'h88FFFF       // UART12 END Address

`endif
