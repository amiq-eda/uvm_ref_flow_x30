/*******************************************************************************
  FILE : apb_transfer26.svh
*******************************************************************************/
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


`ifndef APB_TRANSFER_SV26
`define APB_TRANSFER_SV26

//------------------------------------------------------------------------------
// CLASS26: apb_transfer26 declaration26
//------------------------------------------------------------------------------

class apb_transfer26 extends uvm_sequence_item;                                  

  rand bit [31:0]           addr;
  rand apb_direction_enum26   direction26;
  rand bit [31:0]           data;
  rand int unsigned         transmit_delay26 = 0;
  string                    master26 = "";
  string                    slave26 = "";
   
  constraint c_direction26 { direction26 inside { APB_READ26, APB_WRITE26 }; }
 
  constraint c_transmit_delay26 { transmit_delay26 <= 10 ; }

  `uvm_object_utils_begin(apb_transfer26)
    `uvm_field_int(addr, UVM_DEFAULT)
    `uvm_field_enum(apb_direction_enum26, direction26, UVM_DEFAULT)
    `uvm_field_int(data, UVM_DEFAULT)
    `uvm_field_string(master26, UVM_DEFAULT|UVM_NOCOMPARE)
    `uvm_field_string(slave26, UVM_DEFAULT|UVM_NOCOMPARE)
  `uvm_object_utils_end

  function new (string name = "apb_transfer26");
    super.new(name);
  endfunction

endclass : apb_transfer26

`endif // APB_TRANSFER_SV26
