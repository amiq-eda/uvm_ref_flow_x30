/*-------------------------------------------------------------------------
File2 name   : gpio_pkg2.svh
Title2       : Package2 for GPIO2 OVC2
Project2     :
Created2     :
Description2 : 
Notes2       :  
----------------------------------------------------------------------*/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------

  
`ifndef GPIO_PKG_SVH2
`define GPIO_PKG_SVH2

package gpio_pkg2;

import uvm_pkg::*;
`include "uvm_macros.svh"

//////////////////////////////////////////////////
//        UVM Class2 Forward2 Declarations2        //
//////////////////////////////////////////////////

typedef class gpio_agent2;
typedef class gpio_csr2;
typedef class gpio_driver2;
typedef class gpio_env2;
typedef class gpio_monitor2;
typedef class gpio_simple_trans_seq2;
typedef class gpio_multiple_simple_trans2;
typedef class gpio_sequencer2;
typedef class gpio_transfer2;

//////////////////////////////////////////////////
//              Include2 files                   //
//////////////////////////////////////////////////
`include "gpio_csr2.sv"
`include "gpio_transfer2.sv"
`include "gpio_config2.sv"

`include "gpio_monitor2.sv"
`include "gpio_sequencer2.sv"
`include "gpio_driver2.sv"
`include "gpio_agent2.sv"

`include "gpio_env2.sv"

`include "gpio_seq_lib2.sv"

endpackage : gpio_pkg2

`endif
