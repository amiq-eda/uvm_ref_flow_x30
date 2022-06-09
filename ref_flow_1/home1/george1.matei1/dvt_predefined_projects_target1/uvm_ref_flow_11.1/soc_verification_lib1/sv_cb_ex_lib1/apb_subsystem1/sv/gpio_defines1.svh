/*-------------------------------------------------------------------------
File1 name   : gpio_defines1.svh
Title1       : APB1 - GPIO1 defines1
Project1     :
Created1     :
Description1 : defines1 for the APB1-GPIO1 Environment1
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

`ifndef APB_GPIO_DEFINES_SVH1
`define APB_GPIO_DEFINES_SVH1

`define GPIO_DATA_WIDTH1         32
`define GPIO_BYPASS_MODE_REG1    32'h00
`define GPIO_DIRECTION_MODE_REG1 32'h04
`define GPIO_OUTPUT_ENABLE_REG1  32'h08
`define GPIO_OUTPUT_VALUE_REG1   32'h0C
`define GPIO_INPUT_VALUE_REG1    32'h10
`define GPIO_INT_MASK_REG1       32'h14
`define GPIO_INT_ENABLE_REG1     32'h18
`define GPIO_INT_DISABLE_REG1    32'h1C
`define GPIO_INT_STATUS_REG1     32'h20
`define GPIO_INT_TYPE_REG1       32'h24
`define GPIO_INT_VALUE_REG1      32'h28
`define GPIO_INT_ON_ANY_REG1     32'h2C

`endif
