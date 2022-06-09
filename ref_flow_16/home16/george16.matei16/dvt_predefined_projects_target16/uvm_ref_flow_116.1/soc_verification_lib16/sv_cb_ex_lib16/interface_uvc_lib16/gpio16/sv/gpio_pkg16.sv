/*-------------------------------------------------------------------------
File16 name   : gpio_pkg16.svh
Title16       : Package16 for GPIO16 OVC16
Project16     :
Created16     :
Description16 : 
Notes16       :  
----------------------------------------------------------------------*/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------

  
`ifndef GPIO_PKG_SVH16
`define GPIO_PKG_SVH16

package gpio_pkg16;

import uvm_pkg::*;
`include "uvm_macros.svh"

//////////////////////////////////////////////////
//        UVM Class16 Forward16 Declarations16        //
//////////////////////////////////////////////////

typedef class gpio_agent16;
typedef class gpio_csr16;
typedef class gpio_driver16;
typedef class gpio_env16;
typedef class gpio_monitor16;
typedef class gpio_simple_trans_seq16;
typedef class gpio_multiple_simple_trans16;
typedef class gpio_sequencer16;
typedef class gpio_transfer16;

//////////////////////////////////////////////////
//              Include16 files                   //
//////////////////////////////////////////////////
`include "gpio_csr16.sv"
`include "gpio_transfer16.sv"
`include "gpio_config16.sv"

`include "gpio_monitor16.sv"
`include "gpio_sequencer16.sv"
`include "gpio_driver16.sv"
`include "gpio_agent16.sv"

`include "gpio_env16.sv"

`include "gpio_seq_lib16.sv"

endpackage : gpio_pkg16

`endif
