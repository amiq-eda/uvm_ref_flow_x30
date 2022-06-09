/*******************************************************************************
  FILE : apb_transfer19.svh
*******************************************************************************/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------


`ifndef APB_TRANSFER_SV19
`define APB_TRANSFER_SV19

//------------------------------------------------------------------------------
// CLASS19: apb_transfer19 declaration19
//------------------------------------------------------------------------------

class apb_transfer19 extends uvm_sequence_item;                                  

  rand bit [31:0]           addr;
  rand apb_direction_enum19   direction19;
  rand bit [31:0]           data;
  rand int unsigned         transmit_delay19 = 0;
  string                    master19 = "";
  string                    slave19 = "";
   
  constraint c_direction19 { direction19 inside { APB_READ19, APB_WRITE19 }; }
 
  constraint c_transmit_delay19 { transmit_delay19 <= 10 ; }

  `uvm_object_utils_begin(apb_transfer19)
    `uvm_field_int(addr, UVM_DEFAULT)
    `uvm_field_enum(apb_direction_enum19, direction19, UVM_DEFAULT)
    `uvm_field_int(data, UVM_DEFAULT)
    `uvm_field_string(master19, UVM_DEFAULT|UVM_NOCOMPARE)
    `uvm_field_string(slave19, UVM_DEFAULT|UVM_NOCOMPARE)
  `uvm_object_utils_end

  function new (string name = "apb_transfer19");
    super.new(name);
  endfunction

endclass : apb_transfer19

`endif // APB_TRANSFER_SV19
