/*-------------------------------------------------------------------------
File13 name   : gpio_defines13.svh
Title13       : APB13 - GPIO13 defines13
Project13     :
Created13     :
Description13 : defines13 for the APB13-GPIO13 Environment13
Notes13       : 
----------------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------

`ifndef APB_GPIO_DEFINES_SVH13
`define APB_GPIO_DEFINES_SVH13

`define GPIO_DATA_WIDTH13         32
`define GPIO_BYPASS_MODE_REG13    32'h00
`define GPIO_DIRECTION_MODE_REG13 32'h04
`define GPIO_OUTPUT_ENABLE_REG13  32'h08
`define GPIO_OUTPUT_VALUE_REG13   32'h0C
`define GPIO_INPUT_VALUE_REG13    32'h10
`define GPIO_INT_MASK_REG13       32'h14
`define GPIO_INT_ENABLE_REG13     32'h18
`define GPIO_INT_DISABLE_REG13    32'h1C
`define GPIO_INT_STATUS_REG13     32'h20
`define GPIO_INT_TYPE_REG13       32'h24
`define GPIO_INT_VALUE_REG13      32'h28
`define GPIO_INT_ON_ANY_REG13     32'h2C

`endif
