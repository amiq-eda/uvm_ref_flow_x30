/*-------------------------------------------------------------------------
File19 name   : gpio_pkg19.svh
Title19       : Package19 for GPIO19 OVC19
Project19     :
Created19     :
Description19 : 
Notes19       :  
----------------------------------------------------------------------*/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------

  
`ifndef GPIO_PKG_SVH19
`define GPIO_PKG_SVH19

package gpio_pkg19;

import uvm_pkg::*;
`include "uvm_macros.svh"

//////////////////////////////////////////////////
//        UVM Class19 Forward19 Declarations19        //
//////////////////////////////////////////////////

typedef class gpio_agent19;
typedef class gpio_csr19;
typedef class gpio_driver19;
typedef class gpio_env19;
typedef class gpio_monitor19;
typedef class gpio_simple_trans_seq19;
typedef class gpio_multiple_simple_trans19;
typedef class gpio_sequencer19;
typedef class gpio_transfer19;

//////////////////////////////////////////////////
//              Include19 files                   //
//////////////////////////////////////////////////
`include "gpio_csr19.sv"
`include "gpio_transfer19.sv"
`include "gpio_config19.sv"

`include "gpio_monitor19.sv"
`include "gpio_sequencer19.sv"
`include "gpio_driver19.sv"
`include "gpio_agent19.sv"

`include "gpio_env19.sv"

`include "gpio_seq_lib19.sv"

endpackage : gpio_pkg19

`endif
