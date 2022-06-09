/*-------------------------------------------------------------------------
File28 name   : gpio_defines28.svh
Title28       : APB28 - GPIO28 defines28
Project28     :
Created28     :
Description28 : defines28 for the APB28-GPIO28 Environment28
Notes28       : 
----------------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------

`ifndef APB_GPIO_DEFINES_SVH28
`define APB_GPIO_DEFINES_SVH28

`define GPIO_DATA_WIDTH28         32
`define GPIO_BYPASS_MODE_REG28    32'h00
`define GPIO_DIRECTION_MODE_REG28 32'h04
`define GPIO_OUTPUT_ENABLE_REG28  32'h08
`define GPIO_OUTPUT_VALUE_REG28   32'h0C
`define GPIO_INPUT_VALUE_REG28    32'h10
`define GPIO_INT_MASK_REG28       32'h14
`define GPIO_INT_ENABLE_REG28     32'h18
`define GPIO_INT_DISABLE_REG28    32'h1C
`define GPIO_INT_STATUS_REG28     32'h20
`define GPIO_INT_TYPE_REG28       32'h24
`define GPIO_INT_VALUE_REG28      32'h28
`define GPIO_INT_ON_ANY_REG28     32'h2C

`endif
