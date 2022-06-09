/*******************************************************************************
  FILE : apb_transfer9.svh
*******************************************************************************/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------


`ifndef APB_TRANSFER_SV9
`define APB_TRANSFER_SV9

//------------------------------------------------------------------------------
// CLASS9: apb_transfer9 declaration9
//------------------------------------------------------------------------------

class apb_transfer9 extends uvm_sequence_item;                                  

  rand bit [31:0]           addr;
  rand apb_direction_enum9   direction9;
  rand bit [31:0]           data;
  rand int unsigned         transmit_delay9 = 0;
  string                    master9 = "";
  string                    slave9 = "";
   
  constraint c_direction9 { direction9 inside { APB_READ9, APB_WRITE9 }; }
 
  constraint c_transmit_delay9 { transmit_delay9 <= 10 ; }

  `uvm_object_utils_begin(apb_transfer9)
    `uvm_field_int(addr, UVM_DEFAULT)
    `uvm_field_enum(apb_direction_enum9, direction9, UVM_DEFAULT)
    `uvm_field_int(data, UVM_DEFAULT)
    `uvm_field_string(master9, UVM_DEFAULT|UVM_NOCOMPARE)
    `uvm_field_string(slave9, UVM_DEFAULT|UVM_NOCOMPARE)
  `uvm_object_utils_end

  function new (string name = "apb_transfer9");
    super.new(name);
  endfunction

endclass : apb_transfer9

`endif // APB_TRANSFER_SV9
