/*-------------------------------------------------------------------------
File2 name   : gpio_defines2.svh
Title2       : APB2 - GPIO2 defines2
Project2     :
Created2     :
Description2 : defines2 for the APB2-GPIO2 Environment2
Notes2       : 
----------------------------------------------------------------------*/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------

`ifndef APB_GPIO_DEFINES_SVH2
`define APB_GPIO_DEFINES_SVH2

`define GPIO_DATA_WIDTH2         32
`define GPIO_BYPASS_MODE_REG2    32'h00
`define GPIO_DIRECTION_MODE_REG2 32'h04
`define GPIO_OUTPUT_ENABLE_REG2  32'h08
`define GPIO_OUTPUT_VALUE_REG2   32'h0C
`define GPIO_INPUT_VALUE_REG2    32'h10
`define GPIO_INT_MASK_REG2       32'h14
`define GPIO_INT_ENABLE_REG2     32'h18
`define GPIO_INT_DISABLE_REG2    32'h1C
`define GPIO_INT_STATUS_REG2     32'h20
`define GPIO_INT_TYPE_REG2       32'h24
`define GPIO_INT_VALUE_REG2      32'h28
`define GPIO_INT_ON_ANY_REG2     32'h2C

`endif
