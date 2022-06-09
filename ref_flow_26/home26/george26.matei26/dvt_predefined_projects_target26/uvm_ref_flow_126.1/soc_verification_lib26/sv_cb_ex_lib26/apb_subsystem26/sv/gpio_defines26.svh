/*-------------------------------------------------------------------------
File26 name   : gpio_defines26.svh
Title26       : APB26 - GPIO26 defines26
Project26     :
Created26     :
Description26 : defines26 for the APB26-GPIO26 Environment26
Notes26       : 
----------------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------

`ifndef APB_GPIO_DEFINES_SVH26
`define APB_GPIO_DEFINES_SVH26

`define GPIO_DATA_WIDTH26         32
`define GPIO_BYPASS_MODE_REG26    32'h00
`define GPIO_DIRECTION_MODE_REG26 32'h04
`define GPIO_OUTPUT_ENABLE_REG26  32'h08
`define GPIO_OUTPUT_VALUE_REG26   32'h0C
`define GPIO_INPUT_VALUE_REG26    32'h10
`define GPIO_INT_MASK_REG26       32'h14
`define GPIO_INT_ENABLE_REG26     32'h18
`define GPIO_INT_DISABLE_REG26    32'h1C
`define GPIO_INT_STATUS_REG26     32'h20
`define GPIO_INT_TYPE_REG26       32'h24
`define GPIO_INT_VALUE_REG26      32'h28
`define GPIO_INT_ON_ANY_REG26     32'h2C

`endif
