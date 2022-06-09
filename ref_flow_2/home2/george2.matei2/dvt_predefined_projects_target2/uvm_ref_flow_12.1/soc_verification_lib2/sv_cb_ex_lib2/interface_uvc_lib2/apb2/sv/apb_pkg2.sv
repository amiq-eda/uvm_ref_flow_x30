/*-------------------------------------------------------------------------
File2 name   : apb_pkg2.sv
Title2       : Package2 for APB2 UVC2
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

  
`ifndef APB_PKG_SV2
`define APB_PKG_SV2

package apb_pkg2;

// Import2 the UVM class library  and UVM automation2 macros2
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "apb_config2.sv"
`include "apb_types2.sv"
`include "apb_transfer2.sv"
`include "apb_monitor2.sv"
`include "apb_collector2.sv"

`include "apb_master_driver2.sv"
`include "apb_master_sequencer2.sv"
`include "apb_master_agent2.sv"

`include "apb_slave_driver2.sv"
`include "apb_slave_sequencer2.sv"
`include "apb_slave_agent2.sv"

`include "apb_master_seq_lib2.sv"
`include "apb_slave_seq_lib2.sv"

`include "apb_env2.sv"

`include "reg_to_apb_adapter2.sv"

endpackage : apb_pkg2
`endif  // APB_PKG_SV2
