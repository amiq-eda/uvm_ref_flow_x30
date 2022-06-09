/*-------------------------------------------------------------------------
File12 name   : gpio_pkg12.svh
Title12       : Package12 for GPIO12 OVC12
Project12     :
Created12     :
Description12 : 
Notes12       :  
----------------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------

  
`ifndef GPIO_PKG_SVH12
`define GPIO_PKG_SVH12

package gpio_pkg12;

import uvm_pkg::*;
`include "uvm_macros.svh"

//////////////////////////////////////////////////
//        UVM Class12 Forward12 Declarations12        //
//////////////////////////////////////////////////

typedef class gpio_agent12;
typedef class gpio_csr12;
typedef class gpio_driver12;
typedef class gpio_env12;
typedef class gpio_monitor12;
typedef class gpio_simple_trans_seq12;
typedef class gpio_multiple_simple_trans12;
typedef class gpio_sequencer12;
typedef class gpio_transfer12;

//////////////////////////////////////////////////
//              Include12 files                   //
//////////////////////////////////////////////////
`include "gpio_csr12.sv"
`include "gpio_transfer12.sv"
`include "gpio_config12.sv"

`include "gpio_monitor12.sv"
`include "gpio_sequencer12.sv"
`include "gpio_driver12.sv"
`include "gpio_agent12.sv"

`include "gpio_env12.sv"

`include "gpio_seq_lib12.sv"

endpackage : gpio_pkg12

`endif
