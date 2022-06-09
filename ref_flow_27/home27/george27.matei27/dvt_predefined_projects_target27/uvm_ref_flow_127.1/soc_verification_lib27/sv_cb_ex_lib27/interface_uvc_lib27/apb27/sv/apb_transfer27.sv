/*******************************************************************************
  FILE : apb_transfer27.svh
*******************************************************************************/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


`ifndef APB_TRANSFER_SV27
`define APB_TRANSFER_SV27

//------------------------------------------------------------------------------
// CLASS27: apb_transfer27 declaration27
//------------------------------------------------------------------------------

class apb_transfer27 extends uvm_sequence_item;                                  

  rand bit [31:0]           addr;
  rand apb_direction_enum27   direction27;
  rand bit [31:0]           data;
  rand int unsigned         transmit_delay27 = 0;
  string                    master27 = "";
  string                    slave27 = "";
   
  constraint c_direction27 { direction27 inside { APB_READ27, APB_WRITE27 }; }
 
  constraint c_transmit_delay27 { transmit_delay27 <= 10 ; }

  `uvm_object_utils_begin(apb_transfer27)
    `uvm_field_int(addr, UVM_DEFAULT)
    `uvm_field_enum(apb_direction_enum27, direction27, UVM_DEFAULT)
    `uvm_field_int(data, UVM_DEFAULT)
    `uvm_field_string(master27, UVM_DEFAULT|UVM_NOCOMPARE)
    `uvm_field_string(slave27, UVM_DEFAULT|UVM_NOCOMPARE)
  `uvm_object_utils_end

  function new (string name = "apb_transfer27");
    super.new(name);
  endfunction

endclass : apb_transfer27

`endif // APB_TRANSFER_SV27
