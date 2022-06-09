/*-------------------------------------------------------------------------
File20 name   : gpio_defines20.svh
Title20       : APB20 - GPIO20 defines20
Project20     :
Created20     :
Description20 : defines20 for the APB20-GPIO20 Environment20
Notes20       : 
----------------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------

`ifndef APB_GPIO_DEFINES_SVH20
`define APB_GPIO_DEFINES_SVH20

`define GPIO_DATA_WIDTH20         32
`define GPIO_BYPASS_MODE_REG20    32'h00
`define GPIO_DIRECTION_MODE_REG20 32'h04
`define GPIO_OUTPUT_ENABLE_REG20  32'h08
`define GPIO_OUTPUT_VALUE_REG20   32'h0C
`define GPIO_INPUT_VALUE_REG20    32'h10
`define GPIO_INT_MASK_REG20       32'h14
`define GPIO_INT_ENABLE_REG20     32'h18
`define GPIO_INT_DISABLE_REG20    32'h1C
`define GPIO_INT_STATUS_REG20     32'h20
`define GPIO_INT_TYPE_REG20       32'h24
`define GPIO_INT_VALUE_REG20      32'h28
`define GPIO_INT_ON_ANY_REG20     32'h2C

`endif
