/*-------------------------------------------------------------------------
File16 name   : gpio_defines16.svh
Title16       : APB16 - GPIO16 defines16
Project16     :
Created16     :
Description16 : defines16 for the APB16-GPIO16 Environment16
Notes16       : 
----------------------------------------------------------------------*/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------

`ifndef APB_GPIO_DEFINES_SVH16
`define APB_GPIO_DEFINES_SVH16

`define GPIO_DATA_WIDTH16         32
`define GPIO_BYPASS_MODE_REG16    32'h00
`define GPIO_DIRECTION_MODE_REG16 32'h04
`define GPIO_OUTPUT_ENABLE_REG16  32'h08
`define GPIO_OUTPUT_VALUE_REG16   32'h0C
`define GPIO_INPUT_VALUE_REG16    32'h10
`define GPIO_INT_MASK_REG16       32'h14
`define GPIO_INT_ENABLE_REG16     32'h18
`define GPIO_INT_DISABLE_REG16    32'h1C
`define GPIO_INT_STATUS_REG16     32'h20
`define GPIO_INT_TYPE_REG16       32'h24
`define GPIO_INT_VALUE_REG16      32'h28
`define GPIO_INT_ON_ANY_REG16     32'h2C

`endif
