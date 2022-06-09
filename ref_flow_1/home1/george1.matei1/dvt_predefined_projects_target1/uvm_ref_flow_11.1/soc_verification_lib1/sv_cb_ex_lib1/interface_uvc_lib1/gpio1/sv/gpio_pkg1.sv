/*-------------------------------------------------------------------------
File1 name   : gpio_pkg1.svh
Title1       : Package1 for GPIO1 OVC1
Project1     :
Created1     :
Description1 : 
Notes1       :  
----------------------------------------------------------------------*/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------

  
`ifndef GPIO_PKG_SVH1
`define GPIO_PKG_SVH1

package gpio_pkg1;

import uvm_pkg::*;
`include "uvm_macros.svh"

//////////////////////////////////////////////////
//        UVM Class1 Forward1 Declarations1        //
//////////////////////////////////////////////////

typedef class gpio_agent1;
typedef class gpio_csr1;
typedef class gpio_driver1;
typedef class gpio_env1;
typedef class gpio_monitor1;
typedef class gpio_simple_trans_seq1;
typedef class gpio_multiple_simple_trans1;
typedef class gpio_sequencer1;
typedef class gpio_transfer1;

//////////////////////////////////////////////////
//              Include1 files                   //
//////////////////////////////////////////////////
`include "gpio_csr1.sv"
`include "gpio_transfer1.sv"
`include "gpio_config1.sv"

`include "gpio_monitor1.sv"
`include "gpio_sequencer1.sv"
`include "gpio_driver1.sv"
`include "gpio_agent1.sv"

`include "gpio_env1.sv"

`include "gpio_seq_lib1.sv"

endpackage : gpio_pkg1

`endif
