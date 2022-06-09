/*-------------------------------------------------------------------------
File9 name   : gpio_pkg9.svh
Title9       : Package9 for GPIO9 OVC9
Project9     :
Created9     :
Description9 : 
Notes9       :  
----------------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------

  
`ifndef GPIO_PKG_SVH9
`define GPIO_PKG_SVH9

package gpio_pkg9;

import uvm_pkg::*;
`include "uvm_macros.svh"

//////////////////////////////////////////////////
//        UVM Class9 Forward9 Declarations9        //
//////////////////////////////////////////////////

typedef class gpio_agent9;
typedef class gpio_csr9;
typedef class gpio_driver9;
typedef class gpio_env9;
typedef class gpio_monitor9;
typedef class gpio_simple_trans_seq9;
typedef class gpio_multiple_simple_trans9;
typedef class gpio_sequencer9;
typedef class gpio_transfer9;

//////////////////////////////////////////////////
//              Include9 files                   //
//////////////////////////////////////////////////
`include "gpio_csr9.sv"
`include "gpio_transfer9.sv"
`include "gpio_config9.sv"

`include "gpio_monitor9.sv"
`include "gpio_sequencer9.sv"
`include "gpio_driver9.sv"
`include "gpio_agent9.sv"

`include "gpio_env9.sv"

`include "gpio_seq_lib9.sv"

endpackage : gpio_pkg9

`endif
