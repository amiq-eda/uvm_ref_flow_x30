/*******************************************************************************
  FILE : apb_transfer24.svh
*******************************************************************************/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------


`ifndef APB_TRANSFER_SV24
`define APB_TRANSFER_SV24

//------------------------------------------------------------------------------
// CLASS24: apb_transfer24 declaration24
//------------------------------------------------------------------------------

class apb_transfer24 extends uvm_sequence_item;                                  

  rand bit [31:0]           addr;
  rand apb_direction_enum24   direction24;
  rand bit [31:0]           data;
  rand int unsigned         transmit_delay24 = 0;
  string                    master24 = "";
  string                    slave24 = "";
   
  constraint c_direction24 { direction24 inside { APB_READ24, APB_WRITE24 }; }
 
  constraint c_transmit_delay24 { transmit_delay24 <= 10 ; }

  `uvm_object_utils_begin(apb_transfer24)
    `uvm_field_int(addr, UVM_DEFAULT)
    `uvm_field_enum(apb_direction_enum24, direction24, UVM_DEFAULT)
    `uvm_field_int(data, UVM_DEFAULT)
    `uvm_field_string(master24, UVM_DEFAULT|UVM_NOCOMPARE)
    `uvm_field_string(slave24, UVM_DEFAULT|UVM_NOCOMPARE)
  `uvm_object_utils_end

  function new (string name = "apb_transfer24");
    super.new(name);
  endfunction

endclass : apb_transfer24

`endif // APB_TRANSFER_SV24
