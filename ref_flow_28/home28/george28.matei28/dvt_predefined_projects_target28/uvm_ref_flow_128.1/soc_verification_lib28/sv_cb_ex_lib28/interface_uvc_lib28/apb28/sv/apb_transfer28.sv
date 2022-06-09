/*******************************************************************************
  FILE : apb_transfer28.svh
*******************************************************************************/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------


`ifndef APB_TRANSFER_SV28
`define APB_TRANSFER_SV28

//------------------------------------------------------------------------------
// CLASS28: apb_transfer28 declaration28
//------------------------------------------------------------------------------

class apb_transfer28 extends uvm_sequence_item;                                  

  rand bit [31:0]           addr;
  rand apb_direction_enum28   direction28;
  rand bit [31:0]           data;
  rand int unsigned         transmit_delay28 = 0;
  string                    master28 = "";
  string                    slave28 = "";
   
  constraint c_direction28 { direction28 inside { APB_READ28, APB_WRITE28 }; }
 
  constraint c_transmit_delay28 { transmit_delay28 <= 10 ; }

  `uvm_object_utils_begin(apb_transfer28)
    `uvm_field_int(addr, UVM_DEFAULT)
    `uvm_field_enum(apb_direction_enum28, direction28, UVM_DEFAULT)
    `uvm_field_int(data, UVM_DEFAULT)
    `uvm_field_string(master28, UVM_DEFAULT|UVM_NOCOMPARE)
    `uvm_field_string(slave28, UVM_DEFAULT|UVM_NOCOMPARE)
  `uvm_object_utils_end

  function new (string name = "apb_transfer28");
    super.new(name);
  endfunction

endclass : apb_transfer28

`endif // APB_TRANSFER_SV28
