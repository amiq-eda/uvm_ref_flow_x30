/*-------------------------------------------------------------------------
File11 name   : gpio_defines11.svh
Title11       : APB11 - GPIO11 defines11
Project11     :
Created11     :
Description11 : defines11 for the APB11-GPIO11 Environment11
Notes11       : 
----------------------------------------------------------------------*/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------

`ifndef APB_GPIO_DEFINES_SVH11
`define APB_GPIO_DEFINES_SVH11

`define GPIO_DATA_WIDTH11         32
`define GPIO_BYPASS_MODE_REG11    32'h00
`define GPIO_DIRECTION_MODE_REG11 32'h04
`define GPIO_OUTPUT_ENABLE_REG11  32'h08
`define GPIO_OUTPUT_VALUE_REG11   32'h0C
`define GPIO_INPUT_VALUE_REG11    32'h10
`define GPIO_INT_MASK_REG11       32'h14
`define GPIO_INT_ENABLE_REG11     32'h18
`define GPIO_INT_DISABLE_REG11    32'h1C
`define GPIO_INT_STATUS_REG11     32'h20
`define GPIO_INT_TYPE_REG11       32'h24
`define GPIO_INT_VALUE_REG11      32'h28
`define GPIO_INT_ON_ANY_REG11     32'h2C

`endif
