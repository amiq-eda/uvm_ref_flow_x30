/*******************************************************************************
  FILE : apb_transfer11.svh
*******************************************************************************/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------


`ifndef APB_TRANSFER_SV11
`define APB_TRANSFER_SV11

//------------------------------------------------------------------------------
// CLASS11: apb_transfer11 declaration11
//------------------------------------------------------------------------------

class apb_transfer11 extends uvm_sequence_item;                                  

  rand bit [31:0]           addr;
  rand apb_direction_enum11   direction11;
  rand bit [31:0]           data;
  rand int unsigned         transmit_delay11 = 0;
  string                    master11 = "";
  string                    slave11 = "";
   
  constraint c_direction11 { direction11 inside { APB_READ11, APB_WRITE11 }; }
 
  constraint c_transmit_delay11 { transmit_delay11 <= 10 ; }

  `uvm_object_utils_begin(apb_transfer11)
    `uvm_field_int(addr, UVM_DEFAULT)
    `uvm_field_enum(apb_direction_enum11, direction11, UVM_DEFAULT)
    `uvm_field_int(data, UVM_DEFAULT)
    `uvm_field_string(master11, UVM_DEFAULT|UVM_NOCOMPARE)
    `uvm_field_string(slave11, UVM_DEFAULT|UVM_NOCOMPARE)
  `uvm_object_utils_end

  function new (string name = "apb_transfer11");
    super.new(name);
  endfunction

endclass : apb_transfer11

`endif // APB_TRANSFER_SV11
