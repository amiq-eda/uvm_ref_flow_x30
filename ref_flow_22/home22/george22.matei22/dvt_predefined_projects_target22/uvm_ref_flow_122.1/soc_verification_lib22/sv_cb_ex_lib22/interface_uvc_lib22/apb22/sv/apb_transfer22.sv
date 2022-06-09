/*******************************************************************************
  FILE : apb_transfer22.svh
*******************************************************************************/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------


`ifndef APB_TRANSFER_SV22
`define APB_TRANSFER_SV22

//------------------------------------------------------------------------------
// CLASS22: apb_transfer22 declaration22
//------------------------------------------------------------------------------

class apb_transfer22 extends uvm_sequence_item;                                  

  rand bit [31:0]           addr;
  rand apb_direction_enum22   direction22;
  rand bit [31:0]           data;
  rand int unsigned         transmit_delay22 = 0;
  string                    master22 = "";
  string                    slave22 = "";
   
  constraint c_direction22 { direction22 inside { APB_READ22, APB_WRITE22 }; }
 
  constraint c_transmit_delay22 { transmit_delay22 <= 10 ; }

  `uvm_object_utils_begin(apb_transfer22)
    `uvm_field_int(addr, UVM_DEFAULT)
    `uvm_field_enum(apb_direction_enum22, direction22, UVM_DEFAULT)
    `uvm_field_int(data, UVM_DEFAULT)
    `uvm_field_string(master22, UVM_DEFAULT|UVM_NOCOMPARE)
    `uvm_field_string(slave22, UVM_DEFAULT|UVM_NOCOMPARE)
  `uvm_object_utils_end

  function new (string name = "apb_transfer22");
    super.new(name);
  endfunction

endclass : apb_transfer22

`endif // APB_TRANSFER_SV22
