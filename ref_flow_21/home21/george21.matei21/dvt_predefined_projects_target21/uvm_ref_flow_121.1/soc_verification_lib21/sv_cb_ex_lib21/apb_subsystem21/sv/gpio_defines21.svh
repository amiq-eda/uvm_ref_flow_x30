/*-------------------------------------------------------------------------
File21 name   : gpio_defines21.svh
Title21       : APB21 - GPIO21 defines21
Project21     :
Created21     :
Description21 : defines21 for the APB21-GPIO21 Environment21
Notes21       : 
----------------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------

`ifndef APB_GPIO_DEFINES_SVH21
`define APB_GPIO_DEFINES_SVH21

`define GPIO_DATA_WIDTH21         32
`define GPIO_BYPASS_MODE_REG21    32'h00
`define GPIO_DIRECTION_MODE_REG21 32'h04
`define GPIO_OUTPUT_ENABLE_REG21  32'h08
`define GPIO_OUTPUT_VALUE_REG21   32'h0C
`define GPIO_INPUT_VALUE_REG21    32'h10
`define GPIO_INT_MASK_REG21       32'h14
`define GPIO_INT_ENABLE_REG21     32'h18
`define GPIO_INT_DISABLE_REG21    32'h1C
`define GPIO_INT_STATUS_REG21     32'h20
`define GPIO_INT_TYPE_REG21       32'h24
`define GPIO_INT_VALUE_REG21      32'h28
`define GPIO_INT_ON_ANY_REG21     32'h2C

`endif
