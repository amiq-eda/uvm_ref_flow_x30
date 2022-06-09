/*-------------------------------------------------------------------------
File24 name   : gpio_defines24.svh
Title24       : APB24 - GPIO24 defines24
Project24     :
Created24     :
Description24 : defines24 for the APB24-GPIO24 Environment24
Notes24       : 
----------------------------------------------------------------------*/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------

`ifndef APB_GPIO_DEFINES_SVH24
`define APB_GPIO_DEFINES_SVH24

`define GPIO_DATA_WIDTH24         32
`define GPIO_BYPASS_MODE_REG24    32'h00
`define GPIO_DIRECTION_MODE_REG24 32'h04
`define GPIO_OUTPUT_ENABLE_REG24  32'h08
`define GPIO_OUTPUT_VALUE_REG24   32'h0C
`define GPIO_INPUT_VALUE_REG24    32'h10
`define GPIO_INT_MASK_REG24       32'h14
`define GPIO_INT_ENABLE_REG24     32'h18
`define GPIO_INT_DISABLE_REG24    32'h1C
`define GPIO_INT_STATUS_REG24     32'h20
`define GPIO_INT_TYPE_REG24       32'h24
`define GPIO_INT_VALUE_REG24      32'h28
`define GPIO_INT_ON_ANY_REG24     32'h2C

`endif
