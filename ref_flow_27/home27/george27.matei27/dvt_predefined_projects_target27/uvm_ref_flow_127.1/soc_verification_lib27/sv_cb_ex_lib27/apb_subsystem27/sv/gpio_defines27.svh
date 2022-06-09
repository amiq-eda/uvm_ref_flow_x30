/*-------------------------------------------------------------------------
File27 name   : gpio_defines27.svh
Title27       : APB27 - GPIO27 defines27
Project27     :
Created27     :
Description27 : defines27 for the APB27-GPIO27 Environment27
Notes27       : 
----------------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------

`ifndef APB_GPIO_DEFINES_SVH27
`define APB_GPIO_DEFINES_SVH27

`define GPIO_DATA_WIDTH27         32
`define GPIO_BYPASS_MODE_REG27    32'h00
`define GPIO_DIRECTION_MODE_REG27 32'h04
`define GPIO_OUTPUT_ENABLE_REG27  32'h08
`define GPIO_OUTPUT_VALUE_REG27   32'h0C
`define GPIO_INPUT_VALUE_REG27    32'h10
`define GPIO_INT_MASK_REG27       32'h14
`define GPIO_INT_ENABLE_REG27     32'h18
`define GPIO_INT_DISABLE_REG27    32'h1C
`define GPIO_INT_STATUS_REG27     32'h20
`define GPIO_INT_TYPE_REG27       32'h24
`define GPIO_INT_VALUE_REG27      32'h28
`define GPIO_INT_ON_ANY_REG27     32'h2C

`endif
