/*-------------------------------------------------------------------------
File12 name   : gpio_defines12.svh
Title12       : APB12 - GPIO12 defines12
Project12     :
Created12     :
Description12 : defines12 for the APB12-GPIO12 Environment12
Notes12       : 
----------------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------

`ifndef APB_GPIO_DEFINES_SVH12
`define APB_GPIO_DEFINES_SVH12

`define GPIO_DATA_WIDTH12         32
`define GPIO_BYPASS_MODE_REG12    32'h00
`define GPIO_DIRECTION_MODE_REG12 32'h04
`define GPIO_OUTPUT_ENABLE_REG12  32'h08
`define GPIO_OUTPUT_VALUE_REG12   32'h0C
`define GPIO_INPUT_VALUE_REG12    32'h10
`define GPIO_INT_MASK_REG12       32'h14
`define GPIO_INT_ENABLE_REG12     32'h18
`define GPIO_INT_DISABLE_REG12    32'h1C
`define GPIO_INT_STATUS_REG12     32'h20
`define GPIO_INT_TYPE_REG12       32'h24
`define GPIO_INT_VALUE_REG12      32'h28
`define GPIO_INT_ON_ANY_REG12     32'h2C

`endif
