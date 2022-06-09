/*-------------------------------------------------------------------------
File3 name   : gpio_defines3.svh
Title3       : APB3 - GPIO3 defines3
Project3     :
Created3     :
Description3 : defines3 for the APB3-GPIO3 Environment3
Notes3       : 
----------------------------------------------------------------------*/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------

`ifndef APB_GPIO_DEFINES_SVH3
`define APB_GPIO_DEFINES_SVH3

`define GPIO_DATA_WIDTH3         32
`define GPIO_BYPASS_MODE_REG3    32'h00
`define GPIO_DIRECTION_MODE_REG3 32'h04
`define GPIO_OUTPUT_ENABLE_REG3  32'h08
`define GPIO_OUTPUT_VALUE_REG3   32'h0C
`define GPIO_INPUT_VALUE_REG3    32'h10
`define GPIO_INT_MASK_REG3       32'h14
`define GPIO_INT_ENABLE_REG3     32'h18
`define GPIO_INT_DISABLE_REG3    32'h1C
`define GPIO_INT_STATUS_REG3     32'h20
`define GPIO_INT_TYPE_REG3       32'h24
`define GPIO_INT_VALUE_REG3      32'h28
`define GPIO_INT_ON_ANY_REG3     32'h2C

`endif
