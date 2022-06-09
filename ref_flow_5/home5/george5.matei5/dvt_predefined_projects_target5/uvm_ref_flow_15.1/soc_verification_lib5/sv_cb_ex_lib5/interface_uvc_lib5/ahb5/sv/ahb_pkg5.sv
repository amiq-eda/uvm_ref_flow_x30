// IVB5 checksum5: 720351203
/*-----------------------------------------------------------------
File5 name     : ahb_pkg5.sv
Created5       : Wed5 May5 19 15:42:21 2010
Description5   : This5 file imports5 all the files of the OVC5.
Notes5         :
-----------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------


`ifndef AHB_PKG_SV5
`define AHB_PKG_SV5

package ahb_pkg5;

// UVM class library compiled5 in a package
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "ahb_defines5.sv"
`include "ahb_transfer5.sv"

`include "ahb_master_monitor5.sv"
`include "ahb_master_sequencer5.sv"
`include "ahb_master_driver5.sv"
`include "ahb_master_agent5.sv"
// Can5 include universally5 reusable5 master5 sequences here5.

`include "ahb_slave_monitor5.sv"
`include "ahb_slave_sequencer5.sv"
`include "ahb_slave_driver5.sv"
`include "ahb_slave_agent5.sv"
// Can5 include universally5 reusable5 slave5 sequences here5.

`include "ahb_env5.sv"
`include "reg_to_ahb_adapter5.sv"

endpackage : ahb_pkg5

`endif // AHB_PKG_SV5
