/*-------------------------------------------------------------------------
File30 name   : gpio_pkg30.svh
Title30       : Package30 for GPIO30 OVC30
Project30     :
Created30     :
Description30 : 
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

  
`ifndef GPIO_PKG_SVH30
`define GPIO_PKG_SVH30

package gpio_pkg30;

import uvm_pkg::*;
`include "uvm_macros.svh"

//////////////////////////////////////////////////
//        UVM Class30 Forward30 Declarations30        //
//////////////////////////////////////////////////

typedef class gpio_agent30;
typedef class gpio_csr30;
typedef class gpio_driver30;
typedef class gpio_env30;
typedef class gpio_monitor30;
typedef class gpio_simple_trans_seq30;
typedef class gpio_multiple_simple_trans30;
typedef class gpio_sequencer30;
typedef class gpio_transfer30;

//////////////////////////////////////////////////
//              Include30 files                   //
//////////////////////////////////////////////////
`include "gpio_csr30.sv"
`include "gpio_transfer30.sv"
`include "gpio_config30.sv"

`include "gpio_monitor30.sv"
`include "gpio_sequencer30.sv"
`include "gpio_driver30.sv"
`include "gpio_agent30.sv"

`include "gpio_env30.sv"

`include "gpio_seq_lib30.sv"

endpackage : gpio_pkg30

`endif
