/*-------------------------------------------------------------------------
File22 name   : gpio_defines22.svh
Title22       : APB22 - GPIO22 defines22
Project22     :
Created22     :
Description22 : defines22 for the APB22-GPIO22 Environment22
Notes22       : 
----------------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------

`ifndef APB_GPIO_DEFINES_SVH22
`define APB_GPIO_DEFINES_SVH22

`define GPIO_DATA_WIDTH22         32
`define GPIO_BYPASS_MODE_REG22    32'h00
`define GPIO_DIRECTION_MODE_REG22 32'h04
`define GPIO_OUTPUT_ENABLE_REG22  32'h08
`define GPIO_OUTPUT_VALUE_REG22   32'h0C
`define GPIO_INPUT_VALUE_REG22    32'h10
`define GPIO_INT_MASK_REG22       32'h14
`define GPIO_INT_ENABLE_REG22     32'h18
`define GPIO_INT_DISABLE_REG22    32'h1C
`define GPIO_INT_STATUS_REG22     32'h20
`define GPIO_INT_TYPE_REG22       32'h24
`define GPIO_INT_VALUE_REG22      32'h28
`define GPIO_INT_ON_ANY_REG22     32'h2C

`endif
