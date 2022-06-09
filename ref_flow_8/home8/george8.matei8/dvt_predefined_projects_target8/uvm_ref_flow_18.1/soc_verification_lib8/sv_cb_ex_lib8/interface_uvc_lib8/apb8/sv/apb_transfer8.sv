/*******************************************************************************
  FILE : apb_transfer8.svh
*******************************************************************************/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------


`ifndef APB_TRANSFER_SV8
`define APB_TRANSFER_SV8

//------------------------------------------------------------------------------
// CLASS8: apb_transfer8 declaration8
//------------------------------------------------------------------------------

class apb_transfer8 extends uvm_sequence_item;                                  

  rand bit [31:0]           addr;
  rand apb_direction_enum8   direction8;
  rand bit [31:0]           data;
  rand int unsigned         transmit_delay8 = 0;
  string                    master8 = "";
  string                    slave8 = "";
   
  constraint c_direction8 { direction8 inside { APB_READ8, APB_WRITE8 }; }
 
  constraint c_transmit_delay8 { transmit_delay8 <= 10 ; }

  `uvm_object_utils_begin(apb_transfer8)
    `uvm_field_int(addr, UVM_DEFAULT)
    `uvm_field_enum(apb_direction_enum8, direction8, UVM_DEFAULT)
    `uvm_field_int(data, UVM_DEFAULT)
    `uvm_field_string(master8, UVM_DEFAULT|UVM_NOCOMPARE)
    `uvm_field_string(slave8, UVM_DEFAULT|UVM_NOCOMPARE)
  `uvm_object_utils_end

  function new (string name = "apb_transfer8");
    super.new(name);
  endfunction

endclass : apb_transfer8

`endif // APB_TRANSFER_SV8
