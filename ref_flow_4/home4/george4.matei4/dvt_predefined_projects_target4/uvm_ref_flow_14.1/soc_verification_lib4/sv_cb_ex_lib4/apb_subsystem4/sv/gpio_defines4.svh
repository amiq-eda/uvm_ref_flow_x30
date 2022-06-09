/*-------------------------------------------------------------------------
File4 name   : gpio_defines4.svh
Title4       : APB4 - GPIO4 defines4
Project4     :
Created4     :
Description4 : defines4 for the APB4-GPIO4 Environment4
Notes4       : 
----------------------------------------------------------------------*/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------

`ifndef APB_GPIO_DEFINES_SVH4
`define APB_GPIO_DEFINES_SVH4

`define GPIO_DATA_WIDTH4         32
`define GPIO_BYPASS_MODE_REG4    32'h00
`define GPIO_DIRECTION_MODE_REG4 32'h04
`define GPIO_OUTPUT_ENABLE_REG4  32'h08
`define GPIO_OUTPUT_VALUE_REG4   32'h0C
`define GPIO_INPUT_VALUE_REG4    32'h10
`define GPIO_INT_MASK_REG4       32'h14
`define GPIO_INT_ENABLE_REG4     32'h18
`define GPIO_INT_DISABLE_REG4    32'h1C
`define GPIO_INT_STATUS_REG4     32'h20
`define GPIO_INT_TYPE_REG4       32'h24
`define GPIO_INT_VALUE_REG4      32'h28
`define GPIO_INT_ON_ANY_REG4     32'h2C

`endif
