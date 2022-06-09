/*-------------------------------------------------------------------------
File9 name   : gpio_defines9.svh
Title9       : APB9 - GPIO9 defines9
Project9     :
Created9     :
Description9 : defines9 for the APB9-GPIO9 Environment9
Notes9       : 
----------------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------

`ifndef APB_GPIO_DEFINES_SVH9
`define APB_GPIO_DEFINES_SVH9

`define GPIO_DATA_WIDTH9         32
`define GPIO_BYPASS_MODE_REG9    32'h00
`define GPIO_DIRECTION_MODE_REG9 32'h04
`define GPIO_OUTPUT_ENABLE_REG9  32'h08
`define GPIO_OUTPUT_VALUE_REG9   32'h0C
`define GPIO_INPUT_VALUE_REG9    32'h10
`define GPIO_INT_MASK_REG9       32'h14
`define GPIO_INT_ENABLE_REG9     32'h18
`define GPIO_INT_DISABLE_REG9    32'h1C
`define GPIO_INT_STATUS_REG9     32'h20
`define GPIO_INT_TYPE_REG9       32'h24
`define GPIO_INT_VALUE_REG9      32'h28
`define GPIO_INT_ON_ANY_REG9     32'h2C

`endif
