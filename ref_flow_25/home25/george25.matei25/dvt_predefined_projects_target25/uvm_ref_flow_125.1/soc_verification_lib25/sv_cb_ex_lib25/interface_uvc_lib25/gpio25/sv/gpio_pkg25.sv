/*-------------------------------------------------------------------------
File25 name   : gpio_pkg25.svh
Title25       : Package25 for GPIO25 OVC25
Project25     :
Created25     :
Description25 : 
Notes25       :  
----------------------------------------------------------------------*/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------

  
`ifndef GPIO_PKG_SVH25
`define GPIO_PKG_SVH25

package gpio_pkg25;

import uvm_pkg::*;
`include "uvm_macros.svh"

//////////////////////////////////////////////////
//        UVM Class25 Forward25 Declarations25        //
//////////////////////////////////////////////////

typedef class gpio_agent25;
typedef class gpio_csr25;
typedef class gpio_driver25;
typedef class gpio_env25;
typedef class gpio_monitor25;
typedef class gpio_simple_trans_seq25;
typedef class gpio_multiple_simple_trans25;
typedef class gpio_sequencer25;
typedef class gpio_transfer25;

//////////////////////////////////////////////////
//              Include25 files                   //
//////////////////////////////////////////////////
`include "gpio_csr25.sv"
`include "gpio_transfer25.sv"
`include "gpio_config25.sv"

`include "gpio_monitor25.sv"
`include "gpio_sequencer25.sv"
`include "gpio_driver25.sv"
`include "gpio_agent25.sv"

`include "gpio_env25.sv"

`include "gpio_seq_lib25.sv"

endpackage : gpio_pkg25

`endif
