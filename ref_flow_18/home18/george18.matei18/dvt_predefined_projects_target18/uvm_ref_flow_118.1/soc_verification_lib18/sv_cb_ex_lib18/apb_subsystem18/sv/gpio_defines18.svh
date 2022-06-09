/*-------------------------------------------------------------------------
File18 name   : gpio_defines18.svh
Title18       : APB18 - GPIO18 defines18
Project18     :
Created18     :
Description18 : defines18 for the APB18-GPIO18 Environment18
Notes18       : 
----------------------------------------------------------------------*/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------

`ifndef APB_GPIO_DEFINES_SVH18
`define APB_GPIO_DEFINES_SVH18

`define GPIO_DATA_WIDTH18         32
`define GPIO_BYPASS_MODE_REG18    32'h00
`define GPIO_DIRECTION_MODE_REG18 32'h04
`define GPIO_OUTPUT_ENABLE_REG18  32'h08
`define GPIO_OUTPUT_VALUE_REG18   32'h0C
`define GPIO_INPUT_VALUE_REG18    32'h10
`define GPIO_INT_MASK_REG18       32'h14
`define GPIO_INT_ENABLE_REG18     32'h18
`define GPIO_INT_DISABLE_REG18    32'h1C
`define GPIO_INT_STATUS_REG18     32'h20
`define GPIO_INT_TYPE_REG18       32'h24
`define GPIO_INT_VALUE_REG18      32'h28
`define GPIO_INT_ON_ANY_REG18     32'h2C

`endif
