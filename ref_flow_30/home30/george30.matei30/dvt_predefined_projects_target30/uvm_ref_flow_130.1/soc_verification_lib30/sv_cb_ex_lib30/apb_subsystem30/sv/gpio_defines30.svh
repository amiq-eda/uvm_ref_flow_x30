/*-------------------------------------------------------------------------
File30 name   : gpio_defines30.svh
Title30       : APB30 - GPIO30 defines30
Project30     :
Created30     :
Description30 : defines30 for the APB30-GPIO30 Environment30
Notes30       : 
----------------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------

`ifndef APB_GPIO_DEFINES_SVH30
`define APB_GPIO_DEFINES_SVH30

`define GPIO_DATA_WIDTH30         32
`define GPIO_BYPASS_MODE_REG30    32'h00
`define GPIO_DIRECTION_MODE_REG30 32'h04
`define GPIO_OUTPUT_ENABLE_REG30  32'h08
`define GPIO_OUTPUT_VALUE_REG30   32'h0C
`define GPIO_INPUT_VALUE_REG30    32'h10
`define GPIO_INT_MASK_REG30       32'h14
`define GPIO_INT_ENABLE_REG30     32'h18
`define GPIO_INT_DISABLE_REG30    32'h1C
`define GPIO_INT_STATUS_REG30     32'h20
`define GPIO_INT_TYPE_REG30       32'h24
`define GPIO_INT_VALUE_REG30      32'h28
`define GPIO_INT_ON_ANY_REG30     32'h2C

`endif
