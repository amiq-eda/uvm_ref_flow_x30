/*-------------------------------------------------------------------------
File1 name   : uart_ctrl_defines1.svh
Title1       : UART1 Controller1 defines1
Project1     :
Created1     :
Description1 : defines1 for the UART1 Controller1 Environment1
Notes1       : 
----------------------------------------------------------------------*/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_DEFINES_SVH1
`define APB_SUBSYSTEM_DEFINES_SVH1

`define AM_SPI0_BASE_ADDRESS1    32'h800000      // SPI01 Base1 Address
`define AM_UART0_BASE_ADDRESS1   32'h810000      // UART01 Base1 Address
`define AM_GPIO0_BASE_ADDRESS1   32'h820000      // GPIO01 Base1 Address
`define AM_UART1_BASE_ADDRESS1   32'h880000      // UART11 Base1 Address
`define AM_SPI0_END_ADDRESS1    32'h80FFFF       // SPI01 END Address
`define AM_UART0_END_ADDRESS1   32'h81FFFF       // UART01 END Address
`define AM_GPIO0_END_ADDRESS1   32'h82FFFF       // GPIO01 END Address
`define AM_UART1_END_ADDRESS1   32'h88FFFF       // UART11 END Address

`endif
