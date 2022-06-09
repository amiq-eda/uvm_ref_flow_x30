/*-------------------------------------------------------------------------
File8 name   : gpio_pkg8.svh
Title8       : Package8 for GPIO8 OVC8
Project8     :
Created8     :
Description8 : 
Notes8       :  
----------------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------

  
`ifndef GPIO_PKG_SVH8
`define GPIO_PKG_SVH8

package gpio_pkg8;

import uvm_pkg::*;
`include "uvm_macros.svh"

//////////////////////////////////////////////////
//        UVM Class8 Forward8 Declarations8        //
//////////////////////////////////////////////////

typedef class gpio_agent8;
typedef class gpio_csr8;
typedef class gpio_driver8;
typedef class gpio_env8;
typedef class gpio_monitor8;
typedef class gpio_simple_trans_seq8;
typedef class gpio_multiple_simple_trans8;
typedef class gpio_sequencer8;
typedef class gpio_transfer8;

//////////////////////////////////////////////////
//              Include8 files                   //
//////////////////////////////////////////////////
`include "gpio_csr8.sv"
`include "gpio_transfer8.sv"
`include "gpio_config8.sv"

`include "gpio_monitor8.sv"
`include "gpio_sequencer8.sv"
`include "gpio_driver8.sv"
`include "gpio_agent8.sv"

`include "gpio_env8.sv"

`include "gpio_seq_lib8.sv"

endpackage : gpio_pkg8

`endif
