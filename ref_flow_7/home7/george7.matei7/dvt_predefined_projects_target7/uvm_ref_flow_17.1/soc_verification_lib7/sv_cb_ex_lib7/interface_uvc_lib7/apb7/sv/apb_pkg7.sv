/*-------------------------------------------------------------------------
File7 name   : apb_pkg7.sv
Title7       : Package7 for APB7 UVC7
Project7     :
Created7     :
Description7 : 
Notes7       :  
----------------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------

  
`ifndef APB_PKG_SV7
`define APB_PKG_SV7

package apb_pkg7;

// Import7 the UVM class library  and UVM automation7 macros7
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "apb_config7.sv"
`include "apb_types7.sv"
`include "apb_transfer7.sv"
`include "apb_monitor7.sv"
`include "apb_collector7.sv"

`include "apb_master_driver7.sv"
`include "apb_master_sequencer7.sv"
`include "apb_master_agent7.sv"

`include "apb_slave_driver7.sv"
`include "apb_slave_sequencer7.sv"
`include "apb_slave_agent7.sv"

`include "apb_master_seq_lib7.sv"
`include "apb_slave_seq_lib7.sv"

`include "apb_env7.sv"

`include "reg_to_apb_adapter7.sv"

endpackage : apb_pkg7
`endif  // APB_PKG_SV7
