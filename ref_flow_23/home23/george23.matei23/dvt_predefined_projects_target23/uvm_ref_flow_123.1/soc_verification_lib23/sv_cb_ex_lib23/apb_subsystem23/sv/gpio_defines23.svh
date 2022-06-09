/*-------------------------------------------------------------------------
File23 name   : gpio_defines23.svh
Title23       : APB23 - GPIO23 defines23
Project23     :
Created23     :
Description23 : defines23 for the APB23-GPIO23 Environment23
Notes23       : 
----------------------------------------------------------------------*/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------

`ifndef APB_GPIO_DEFINES_SVH23
`define APB_GPIO_DEFINES_SVH23

`define GPIO_DATA_WIDTH23         32
`define GPIO_BYPASS_MODE_REG23    32'h00
`define GPIO_DIRECTION_MODE_REG23 32'h04
`define GPIO_OUTPUT_ENABLE_REG23  32'h08
`define GPIO_OUTPUT_VALUE_REG23   32'h0C
`define GPIO_INPUT_VALUE_REG23    32'h10
`define GPIO_INT_MASK_REG23       32'h14
`define GPIO_INT_ENABLE_REG23     32'h18
`define GPIO_INT_DISABLE_REG23    32'h1C
`define GPIO_INT_STATUS_REG23     32'h20
`define GPIO_INT_TYPE_REG23       32'h24
`define GPIO_INT_VALUE_REG23      32'h28
`define GPIO_INT_ON_ANY_REG23     32'h2C

`endif
