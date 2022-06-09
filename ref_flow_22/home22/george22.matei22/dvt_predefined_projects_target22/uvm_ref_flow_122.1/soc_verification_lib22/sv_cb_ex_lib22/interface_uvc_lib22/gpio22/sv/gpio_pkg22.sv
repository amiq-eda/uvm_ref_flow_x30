/*-------------------------------------------------------------------------
File22 name   : gpio_pkg22.svh
Title22       : Package22 for GPIO22 OVC22
Project22     :
Created22     :
Description22 : 
Notes22       :  
----------------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------

  
`ifndef GPIO_PKG_SVH22
`define GPIO_PKG_SVH22

package gpio_pkg22;

import uvm_pkg::*;
`include "uvm_macros.svh"

//////////////////////////////////////////////////
//        UVM Class22 Forward22 Declarations22        //
//////////////////////////////////////////////////

typedef class gpio_agent22;
typedef class gpio_csr22;
typedef class gpio_driver22;
typedef class gpio_env22;
typedef class gpio_monitor22;
typedef class gpio_simple_trans_seq22;
typedef class gpio_multiple_simple_trans22;
typedef class gpio_sequencer22;
typedef class gpio_transfer22;

//////////////////////////////////////////////////
//              Include22 files                   //
//////////////////////////////////////////////////
`include "gpio_csr22.sv"
`include "gpio_transfer22.sv"
`include "gpio_config22.sv"

`include "gpio_monitor22.sv"
`include "gpio_sequencer22.sv"
`include "gpio_driver22.sv"
`include "gpio_agent22.sv"

`include "gpio_env22.sv"

`include "gpio_seq_lib22.sv"

endpackage : gpio_pkg22

`endif
