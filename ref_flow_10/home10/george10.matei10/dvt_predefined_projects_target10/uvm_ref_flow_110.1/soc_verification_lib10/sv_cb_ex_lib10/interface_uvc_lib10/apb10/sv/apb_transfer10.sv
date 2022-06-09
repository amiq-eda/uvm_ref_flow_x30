/*******************************************************************************
  FILE : apb_transfer10.svh
*******************************************************************************/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------


`ifndef APB_TRANSFER_SV10
`define APB_TRANSFER_SV10

//------------------------------------------------------------------------------
// CLASS10: apb_transfer10 declaration10
//------------------------------------------------------------------------------

class apb_transfer10 extends uvm_sequence_item;                                  

  rand bit [31:0]           addr;
  rand apb_direction_enum10   direction10;
  rand bit [31:0]           data;
  rand int unsigned         transmit_delay10 = 0;
  string                    master10 = "";
  string                    slave10 = "";
   
  constraint c_direction10 { direction10 inside { APB_READ10, APB_WRITE10 }; }
 
  constraint c_transmit_delay10 { transmit_delay10 <= 10 ; }

  `uvm_object_utils_begin(apb_transfer10)
    `uvm_field_int(addr, UVM_DEFAULT)
    `uvm_field_enum(apb_direction_enum10, direction10, UVM_DEFAULT)
    `uvm_field_int(data, UVM_DEFAULT)
    `uvm_field_string(master10, UVM_DEFAULT|UVM_NOCOMPARE)
    `uvm_field_string(slave10, UVM_DEFAULT|UVM_NOCOMPARE)
  `uvm_object_utils_end

  function new (string name = "apb_transfer10");
    super.new(name);
  endfunction

endclass : apb_transfer10

`endif // APB_TRANSFER_SV10
