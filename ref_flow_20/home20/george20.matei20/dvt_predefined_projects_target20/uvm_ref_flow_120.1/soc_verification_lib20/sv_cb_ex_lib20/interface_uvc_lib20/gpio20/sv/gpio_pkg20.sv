/*-------------------------------------------------------------------------
File20 name   : gpio_pkg20.svh
Title20       : Package20 for GPIO20 OVC20
Project20     :
Created20     :
Description20 : 
Notes20       :  
----------------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------

  
`ifndef GPIO_PKG_SVH20
`define GPIO_PKG_SVH20

package gpio_pkg20;

import uvm_pkg::*;
`include "uvm_macros.svh"

//////////////////////////////////////////////////
//        UVM Class20 Forward20 Declarations20        //
//////////////////////////////////////////////////

typedef class gpio_agent20;
typedef class gpio_csr20;
typedef class gpio_driver20;
typedef class gpio_env20;
typedef class gpio_monitor20;
typedef class gpio_simple_trans_seq20;
typedef class gpio_multiple_simple_trans20;
typedef class gpio_sequencer20;
typedef class gpio_transfer20;

//////////////////////////////////////////////////
//              Include20 files                   //
//////////////////////////////////////////////////
`include "gpio_csr20.sv"
`include "gpio_transfer20.sv"
`include "gpio_config20.sv"

`include "gpio_monitor20.sv"
`include "gpio_sequencer20.sv"
`include "gpio_driver20.sv"
`include "gpio_agent20.sv"

`include "gpio_env20.sv"

`include "gpio_seq_lib20.sv"

endpackage : gpio_pkg20

`endif
