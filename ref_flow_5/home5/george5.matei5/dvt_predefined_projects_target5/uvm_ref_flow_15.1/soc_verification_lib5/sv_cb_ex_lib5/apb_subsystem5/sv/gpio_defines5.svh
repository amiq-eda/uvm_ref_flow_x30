/*-------------------------------------------------------------------------
File5 name   : gpio_defines5.svh
Title5       : APB5 - GPIO5 defines5
Project5     :
Created5     :
Description5 : defines5 for the APB5-GPIO5 Environment5
Notes5       : 
----------------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------

`ifndef APB_GPIO_DEFINES_SVH5
`define APB_GPIO_DEFINES_SVH5

`define GPIO_DATA_WIDTH5         32
`define GPIO_BYPASS_MODE_REG5    32'h00
`define GPIO_DIRECTION_MODE_REG5 32'h04
`define GPIO_OUTPUT_ENABLE_REG5  32'h08
`define GPIO_OUTPUT_VALUE_REG5   32'h0C
`define GPIO_INPUT_VALUE_REG5    32'h10
`define GPIO_INT_MASK_REG5       32'h14
`define GPIO_INT_ENABLE_REG5     32'h18
`define GPIO_INT_DISABLE_REG5    32'h1C
`define GPIO_INT_STATUS_REG5     32'h20
`define GPIO_INT_TYPE_REG5       32'h24
`define GPIO_INT_VALUE_REG5      32'h28
`define GPIO_INT_ON_ANY_REG5     32'h2C

`endif
