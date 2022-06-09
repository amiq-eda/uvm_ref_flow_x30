/*******************************************************************************
  FILE : apb_transfer16.svh
*******************************************************************************/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------


`ifndef APB_TRANSFER_SV16
`define APB_TRANSFER_SV16

//------------------------------------------------------------------------------
// CLASS16: apb_transfer16 declaration16
//------------------------------------------------------------------------------

class apb_transfer16 extends uvm_sequence_item;                                  

  rand bit [31:0]           addr;
  rand apb_direction_enum16   direction16;
  rand bit [31:0]           data;
  rand int unsigned         transmit_delay16 = 0;
  string                    master16 = "";
  string                    slave16 = "";
   
  constraint c_direction16 { direction16 inside { APB_READ16, APB_WRITE16 }; }
 
  constraint c_transmit_delay16 { transmit_delay16 <= 10 ; }

  `uvm_object_utils_begin(apb_transfer16)
    `uvm_field_int(addr, UVM_DEFAULT)
    `uvm_field_enum(apb_direction_enum16, direction16, UVM_DEFAULT)
    `uvm_field_int(data, UVM_DEFAULT)
    `uvm_field_string(master16, UVM_DEFAULT|UVM_NOCOMPARE)
    `uvm_field_string(slave16, UVM_DEFAULT|UVM_NOCOMPARE)
  `uvm_object_utils_end

  function new (string name = "apb_transfer16");
    super.new(name);
  endfunction

endclass : apb_transfer16

`endif // APB_TRANSFER_SV16
