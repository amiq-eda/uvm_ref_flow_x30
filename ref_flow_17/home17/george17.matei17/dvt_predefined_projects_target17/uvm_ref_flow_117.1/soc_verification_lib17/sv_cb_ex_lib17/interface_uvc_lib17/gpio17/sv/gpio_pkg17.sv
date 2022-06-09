/*-------------------------------------------------------------------------
File17 name   : gpio_pkg17.svh
Title17       : Package17 for GPIO17 OVC17
Project17     :
Created17     :
Description17 : 
Notes17       :  
----------------------------------------------------------------------*/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------

  
`ifndef GPIO_PKG_SVH17
`define GPIO_PKG_SVH17

package gpio_pkg17;

import uvm_pkg::*;
`include "uvm_macros.svh"

//////////////////////////////////////////////////
//        UVM Class17 Forward17 Declarations17        //
//////////////////////////////////////////////////

typedef class gpio_agent17;
typedef class gpio_csr17;
typedef class gpio_driver17;
typedef class gpio_env17;
typedef class gpio_monitor17;
typedef class gpio_simple_trans_seq17;
typedef class gpio_multiple_simple_trans17;
typedef class gpio_sequencer17;
typedef class gpio_transfer17;

//////////////////////////////////////////////////
//              Include17 files                   //
//////////////////////////////////////////////////
`include "gpio_csr17.sv"
`include "gpio_transfer17.sv"
`include "gpio_config17.sv"

`include "gpio_monitor17.sv"
`include "gpio_sequencer17.sv"
`include "gpio_driver17.sv"
`include "gpio_agent17.sv"

`include "gpio_env17.sv"

`include "gpio_seq_lib17.sv"

endpackage : gpio_pkg17

`endif
