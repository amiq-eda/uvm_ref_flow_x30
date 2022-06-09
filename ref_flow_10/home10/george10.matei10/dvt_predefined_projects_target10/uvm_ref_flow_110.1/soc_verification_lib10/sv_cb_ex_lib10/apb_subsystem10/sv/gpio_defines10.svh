/*-------------------------------------------------------------------------
File10 name   : gpio_defines10.svh
Title10       : APB10 - GPIO10 defines10
Project10     :
Created10     :
Description10 : defines10 for the APB10-GPIO10 Environment10
Notes10       : 
----------------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------

`ifndef APB_GPIO_DEFINES_SVH10
`define APB_GPIO_DEFINES_SVH10

`define GPIO_DATA_WIDTH10         32
`define GPIO_BYPASS_MODE_REG10    32'h00
`define GPIO_DIRECTION_MODE_REG10 32'h04
`define GPIO_OUTPUT_ENABLE_REG10  32'h08
`define GPIO_OUTPUT_VALUE_REG10   32'h0C
`define GPIO_INPUT_VALUE_REG10    32'h10
`define GPIO_INT_MASK_REG10       32'h14
`define GPIO_INT_ENABLE_REG10     32'h18
`define GPIO_INT_DISABLE_REG10    32'h1C
`define GPIO_INT_STATUS_REG10     32'h20
`define GPIO_INT_TYPE_REG10       32'h24
`define GPIO_INT_VALUE_REG10      32'h28
`define GPIO_INT_ON_ANY_REG10     32'h2C

`endif
