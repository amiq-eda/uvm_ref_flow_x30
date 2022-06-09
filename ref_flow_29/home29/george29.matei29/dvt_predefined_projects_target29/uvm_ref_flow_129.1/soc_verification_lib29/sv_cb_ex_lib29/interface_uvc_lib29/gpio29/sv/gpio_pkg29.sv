/*-------------------------------------------------------------------------
File29 name   : gpio_pkg29.svh
Title29       : Package29 for GPIO29 OVC29
Project29     :
Created29     :
Description29 : 
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

  
`ifndef GPIO_PKG_SVH29
`define GPIO_PKG_SVH29

package gpio_pkg29;

import uvm_pkg::*;
`include "uvm_macros.svh"

//////////////////////////////////////////////////
//        UVM Class29 Forward29 Declarations29        //
//////////////////////////////////////////////////

typedef class gpio_agent29;
typedef class gpio_csr29;
typedef class gpio_driver29;
typedef class gpio_env29;
typedef class gpio_monitor29;
typedef class gpio_simple_trans_seq29;
typedef class gpio_multiple_simple_trans29;
typedef class gpio_sequencer29;
typedef class gpio_transfer29;

//////////////////////////////////////////////////
//              Include29 files                   //
//////////////////////////////////////////////////
`include "gpio_csr29.sv"
`include "gpio_transfer29.sv"
`include "gpio_config29.sv"

`include "gpio_monitor29.sv"
`include "gpio_sequencer29.sv"
`include "gpio_driver29.sv"
`include "gpio_agent29.sv"

`include "gpio_env29.sv"

`include "gpio_seq_lib29.sv"

endpackage : gpio_pkg29

`endif
