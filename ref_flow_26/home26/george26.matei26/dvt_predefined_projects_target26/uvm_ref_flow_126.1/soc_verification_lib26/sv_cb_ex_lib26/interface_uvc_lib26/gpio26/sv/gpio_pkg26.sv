/*-------------------------------------------------------------------------
File26 name   : gpio_pkg26.svh
Title26       : Package26 for GPIO26 OVC26
Project26     :
Created26     :
Description26 : 
Notes26       :  
----------------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------

  
`ifndef GPIO_PKG_SVH26
`define GPIO_PKG_SVH26

package gpio_pkg26;

import uvm_pkg::*;
`include "uvm_macros.svh"

//////////////////////////////////////////////////
//        UVM Class26 Forward26 Declarations26        //
//////////////////////////////////////////////////

typedef class gpio_agent26;
typedef class gpio_csr26;
typedef class gpio_driver26;
typedef class gpio_env26;
typedef class gpio_monitor26;
typedef class gpio_simple_trans_seq26;
typedef class gpio_multiple_simple_trans26;
typedef class gpio_sequencer26;
typedef class gpio_transfer26;

//////////////////////////////////////////////////
//              Include26 files                   //
//////////////////////////////////////////////////
`include "gpio_csr26.sv"
`include "gpio_transfer26.sv"
`include "gpio_config26.sv"

`include "gpio_monitor26.sv"
`include "gpio_sequencer26.sv"
`include "gpio_driver26.sv"
`include "gpio_agent26.sv"

`include "gpio_env26.sv"

`include "gpio_seq_lib26.sv"

endpackage : gpio_pkg26

`endif
