/*-------------------------------------------------------------------------
File19 name   : gpio_defines19.svh
Title19       : APB19 - GPIO19 defines19
Project19     :
Created19     :
Description19 : defines19 for the APB19-GPIO19 Environment19
Notes19       : 
----------------------------------------------------------------------*/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------

`ifndef APB_GPIO_DEFINES_SVH19
`define APB_GPIO_DEFINES_SVH19

`define GPIO_DATA_WIDTH19         32
`define GPIO_BYPASS_MODE_REG19    32'h00
`define GPIO_DIRECTION_MODE_REG19 32'h04
`define GPIO_OUTPUT_ENABLE_REG19  32'h08
`define GPIO_OUTPUT_VALUE_REG19   32'h0C
`define GPIO_INPUT_VALUE_REG19    32'h10
`define GPIO_INT_MASK_REG19       32'h14
`define GPIO_INT_ENABLE_REG19     32'h18
`define GPIO_INT_DISABLE_REG19    32'h1C
`define GPIO_INT_STATUS_REG19     32'h20
`define GPIO_INT_TYPE_REG19       32'h24
`define GPIO_INT_VALUE_REG19      32'h28
`define GPIO_INT_ON_ANY_REG19     32'h2C

`endif
