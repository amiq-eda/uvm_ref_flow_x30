/*-------------------------------------------------------------------------
File1 name   : apb_pkg1.sv
Title1       : Package1 for APB1 UVC1
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

  
`ifndef APB_PKG_SV1
`define APB_PKG_SV1

package apb_pkg1;

// Import1 the UVM class library  and UVM automation1 macros1
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "apb_config1.sv"
`include "apb_types1.sv"
`include "apb_transfer1.sv"
`include "apb_monitor1.sv"
`include "apb_collector1.sv"

`include "apb_master_driver1.sv"
`include "apb_master_sequencer1.sv"
`include "apb_master_agent1.sv"

`include "apb_slave_driver1.sv"
`include "apb_slave_sequencer1.sv"
`include "apb_slave_agent1.sv"

`include "apb_master_seq_lib1.sv"
`include "apb_slave_seq_lib1.sv"

`include "apb_env1.sv"

`include "reg_to_apb_adapter1.sv"

endpackage : apb_pkg1
`endif  // APB_PKG_SV1
