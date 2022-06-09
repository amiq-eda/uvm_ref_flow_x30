/*-------------------------------------------------------------------------
File6 name   : gpio_defines6.svh
Title6       : APB6 - GPIO6 defines6
Project6     :
Created6     :
Description6 : defines6 for the APB6-GPIO6 Environment6
Notes6       : 
----------------------------------------------------------------------*/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------

`ifndef APB_GPIO_DEFINES_SVH6
`define APB_GPIO_DEFINES_SVH6

`define GPIO_DATA_WIDTH6         32
`define GPIO_BYPASS_MODE_REG6    32'h00
`define GPIO_DIRECTION_MODE_REG6 32'h04
`define GPIO_OUTPUT_ENABLE_REG6  32'h08
`define GPIO_OUTPUT_VALUE_REG6   32'h0C
`define GPIO_INPUT_VALUE_REG6    32'h10
`define GPIO_INT_MASK_REG6       32'h14
`define GPIO_INT_ENABLE_REG6     32'h18
`define GPIO_INT_DISABLE_REG6    32'h1C
`define GPIO_INT_STATUS_REG6     32'h20
`define GPIO_INT_TYPE_REG6       32'h24
`define GPIO_INT_VALUE_REG6      32'h28
`define GPIO_INT_ON_ANY_REG6     32'h2C

`endif
