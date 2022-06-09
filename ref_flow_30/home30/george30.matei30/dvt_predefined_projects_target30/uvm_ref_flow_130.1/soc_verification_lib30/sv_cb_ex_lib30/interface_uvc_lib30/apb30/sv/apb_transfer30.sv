/*******************************************************************************
  FILE : apb_transfer30.svh
*******************************************************************************/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


`ifndef APB_TRANSFER_SV30
`define APB_TRANSFER_SV30

//------------------------------------------------------------------------------
// CLASS30: apb_transfer30 declaration30
//------------------------------------------------------------------------------

class apb_transfer30 extends uvm_sequence_item;                                  

  rand bit [31:0]           addr;
  rand apb_direction_enum30   direction30;
  rand bit [31:0]           data;
  rand int unsigned         transmit_delay30 = 0;
  string                    master30 = "";
  string                    slave30 = "";
   
  constraint c_direction30 { direction30 inside { APB_READ30, APB_WRITE30 }; }
 
  constraint c_transmit_delay30 { transmit_delay30 <= 10 ; }

  `uvm_object_utils_begin(apb_transfer30)
    `uvm_field_int(addr, UVM_DEFAULT)
    `uvm_field_enum(apb_direction_enum30, direction30, UVM_DEFAULT)
    `uvm_field_int(data, UVM_DEFAULT)
    `uvm_field_string(master30, UVM_DEFAULT|UVM_NOCOMPARE)
    `uvm_field_string(slave30, UVM_DEFAULT|UVM_NOCOMPARE)
  `uvm_object_utils_end

  function new (string name = "apb_transfer30");
    super.new(name);
  endfunction

endclass : apb_transfer30

`endif // APB_TRANSFER_SV30
