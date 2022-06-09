/*-------------------------------------------------------------------------
File27 name   : gpio_pkg27.svh
Title27       : Package27 for GPIO27 OVC27
Project27     :
Created27     :
Description27 : 
Notes27       :  
----------------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------

  
`ifndef GPIO_PKG_SVH27
`define GPIO_PKG_SVH27

package gpio_pkg27;

import uvm_pkg::*;
`include "uvm_macros.svh"

//////////////////////////////////////////////////
//        UVM Class27 Forward27 Declarations27        //
//////////////////////////////////////////////////

typedef class gpio_agent27;
typedef class gpio_csr27;
typedef class gpio_driver27;
typedef class gpio_env27;
typedef class gpio_monitor27;
typedef class gpio_simple_trans_seq27;
typedef class gpio_multiple_simple_trans27;
typedef class gpio_sequencer27;
typedef class gpio_transfer27;

//////////////////////////////////////////////////
//              Include27 files                   //
//////////////////////////////////////////////////
`include "gpio_csr27.sv"
`include "gpio_transfer27.sv"
`include "gpio_config27.sv"

`include "gpio_monitor27.sv"
`include "gpio_sequencer27.sv"
`include "gpio_driver27.sv"
`include "gpio_agent27.sv"

`include "gpio_env27.sv"

`include "gpio_seq_lib27.sv"

endpackage : gpio_pkg27

`endif
