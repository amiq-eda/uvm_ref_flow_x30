/*-------------------------------------------------------------------------
File29 name   : gpio_defines29.svh
Title29       : APB29 - GPIO29 defines29
Project29     :
Created29     :
Description29 : defines29 for the APB29-GPIO29 Environment29
Notes29       : 
----------------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------

`ifndef APB_GPIO_DEFINES_SVH29
`define APB_GPIO_DEFINES_SVH29

`define GPIO_DATA_WIDTH29         32
`define GPIO_BYPASS_MODE_REG29    32'h00
`define GPIO_DIRECTION_MODE_REG29 32'h04
`define GPIO_OUTPUT_ENABLE_REG29  32'h08
`define GPIO_OUTPUT_VALUE_REG29   32'h0C
`define GPIO_INPUT_VALUE_REG29    32'h10
`define GPIO_INT_MASK_REG29       32'h14
`define GPIO_INT_ENABLE_REG29     32'h18
`define GPIO_INT_DISABLE_REG29    32'h1C
`define GPIO_INT_STATUS_REG29     32'h20
`define GPIO_INT_TYPE_REG29       32'h24
`define GPIO_INT_VALUE_REG29      32'h28
`define GPIO_INT_ON_ANY_REG29     32'h2C

`endif
