/*-------------------------------------------------------------------------
File8 name   : gpio_defines8.svh
Title8       : APB8 - GPIO8 defines8
Project8     :
Created8     :
Description8 : defines8 for the APB8-GPIO8 Environment8
Notes8       : 
----------------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------

`ifndef APB_GPIO_DEFINES_SVH8
`define APB_GPIO_DEFINES_SVH8

`define GPIO_DATA_WIDTH8         32
`define GPIO_BYPASS_MODE_REG8    32'h00
`define GPIO_DIRECTION_MODE_REG8 32'h04
`define GPIO_OUTPUT_ENABLE_REG8  32'h08
`define GPIO_OUTPUT_VALUE_REG8   32'h0C
`define GPIO_INPUT_VALUE_REG8    32'h10
`define GPIO_INT_MASK_REG8       32'h14
`define GPIO_INT_ENABLE_REG8     32'h18
`define GPIO_INT_DISABLE_REG8    32'h1C
`define GPIO_INT_STATUS_REG8     32'h20
`define GPIO_INT_TYPE_REG8       32'h24
`define GPIO_INT_VALUE_REG8      32'h28
`define GPIO_INT_ON_ANY_REG8     32'h2C

`endif
