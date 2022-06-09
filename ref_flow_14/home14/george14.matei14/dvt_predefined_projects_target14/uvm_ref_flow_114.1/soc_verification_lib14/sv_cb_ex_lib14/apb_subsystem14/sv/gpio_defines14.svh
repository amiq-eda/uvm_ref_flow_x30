/*-------------------------------------------------------------------------
File14 name   : gpio_defines14.svh
Title14       : APB14 - GPIO14 defines14
Project14     :
Created14     :
Description14 : defines14 for the APB14-GPIO14 Environment14
Notes14       : 
----------------------------------------------------------------------*/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------

`ifndef APB_GPIO_DEFINES_SVH14
`define APB_GPIO_DEFINES_SVH14

`define GPIO_DATA_WIDTH14         32
`define GPIO_BYPASS_MODE_REG14    32'h00
`define GPIO_DIRECTION_MODE_REG14 32'h04
`define GPIO_OUTPUT_ENABLE_REG14  32'h08
`define GPIO_OUTPUT_VALUE_REG14   32'h0C
`define GPIO_INPUT_VALUE_REG14    32'h10
`define GPIO_INT_MASK_REG14       32'h14
`define GPIO_INT_ENABLE_REG14     32'h18
`define GPIO_INT_DISABLE_REG14    32'h1C
`define GPIO_INT_STATUS_REG14     32'h20
`define GPIO_INT_TYPE_REG14       32'h24
`define GPIO_INT_VALUE_REG14      32'h28
`define GPIO_INT_ON_ANY_REG14     32'h2C

`endif
