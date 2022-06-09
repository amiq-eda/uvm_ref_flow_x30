/*-------------------------------------------------------------------------
File15 name   : gpio_defines15.svh
Title15       : APB15 - GPIO15 defines15
Project15     :
Created15     :
Description15 : defines15 for the APB15-GPIO15 Environment15
Notes15       : 
----------------------------------------------------------------------*/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------

`ifndef APB_GPIO_DEFINES_SVH15
`define APB_GPIO_DEFINES_SVH15

`define GPIO_DATA_WIDTH15         32
`define GPIO_BYPASS_MODE_REG15    32'h00
`define GPIO_DIRECTION_MODE_REG15 32'h04
`define GPIO_OUTPUT_ENABLE_REG15  32'h08
`define GPIO_OUTPUT_VALUE_REG15   32'h0C
`define GPIO_INPUT_VALUE_REG15    32'h10
`define GPIO_INT_MASK_REG15       32'h14
`define GPIO_INT_ENABLE_REG15     32'h18
`define GPIO_INT_DISABLE_REG15    32'h1C
`define GPIO_INT_STATUS_REG15     32'h20
`define GPIO_INT_TYPE_REG15       32'h24
`define GPIO_INT_VALUE_REG15      32'h28
`define GPIO_INT_ON_ANY_REG15     32'h2C

`endif
