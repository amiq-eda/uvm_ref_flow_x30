/*-------------------------------------------------------------------------
File7 name   : gpio_defines7.svh
Title7       : APB7 - GPIO7 defines7
Project7     :
Created7     :
Description7 : defines7 for the APB7-GPIO7 Environment7
Notes7       : 
----------------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------

`ifndef APB_GPIO_DEFINES_SVH7
`define APB_GPIO_DEFINES_SVH7

`define GPIO_DATA_WIDTH7         32
`define GPIO_BYPASS_MODE_REG7    32'h00
`define GPIO_DIRECTION_MODE_REG7 32'h04
`define GPIO_OUTPUT_ENABLE_REG7  32'h08
`define GPIO_OUTPUT_VALUE_REG7   32'h0C
`define GPIO_INPUT_VALUE_REG7    32'h10
`define GPIO_INT_MASK_REG7       32'h14
`define GPIO_INT_ENABLE_REG7     32'h18
`define GPIO_INT_DISABLE_REG7    32'h1C
`define GPIO_INT_STATUS_REG7     32'h20
`define GPIO_INT_TYPE_REG7       32'h24
`define GPIO_INT_VALUE_REG7      32'h28
`define GPIO_INT_ON_ANY_REG7     32'h2C

`endif
