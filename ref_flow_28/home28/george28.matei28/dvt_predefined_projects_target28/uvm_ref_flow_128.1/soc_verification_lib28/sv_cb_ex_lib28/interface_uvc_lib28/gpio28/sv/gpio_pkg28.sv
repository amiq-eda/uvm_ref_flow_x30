/*-------------------------------------------------------------------------
File28 name   : gpio_pkg28.svh
Title28       : Package28 for GPIO28 OVC28
Project28     :
Created28     :
Description28 : 
Notes28       :  
----------------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------

  
`ifndef GPIO_PKG_SVH28
`define GPIO_PKG_SVH28

package gpio_pkg28;

import uvm_pkg::*;
`include "uvm_macros.svh"

//////////////////////////////////////////////////
//        UVM Class28 Forward28 Declarations28        //
//////////////////////////////////////////////////

typedef class gpio_agent28;
typedef class gpio_csr28;
typedef class gpio_driver28;
typedef class gpio_env28;
typedef class gpio_monitor28;
typedef class gpio_simple_trans_seq28;
typedef class gpio_multiple_simple_trans28;
typedef class gpio_sequencer28;
typedef class gpio_transfer28;

//////////////////////////////////////////////////
//              Include28 files                   //
//////////////////////////////////////////////////
`include "gpio_csr28.sv"
`include "gpio_transfer28.sv"
`include "gpio_config28.sv"

`include "gpio_monitor28.sv"
`include "gpio_sequencer28.sv"
`include "gpio_driver28.sv"
`include "gpio_agent28.sv"

`include "gpio_env28.sv"

`include "gpio_seq_lib28.sv"

endpackage : gpio_pkg28

`endif
