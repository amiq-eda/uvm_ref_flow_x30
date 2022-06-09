/*******************************************************************************
  FILE : apb_transfer12.svh
*******************************************************************************/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------


`ifndef APB_TRANSFER_SV12
`define APB_TRANSFER_SV12

//------------------------------------------------------------------------------
// CLASS12: apb_transfer12 declaration12
//------------------------------------------------------------------------------

class apb_transfer12 extends uvm_sequence_item;                                  

  rand bit [31:0]           addr;
  rand apb_direction_enum12   direction12;
  rand bit [31:0]           data;
  rand int unsigned         transmit_delay12 = 0;
  string                    master12 = "";
  string                    slave12 = "";
   
  constraint c_direction12 { direction12 inside { APB_READ12, APB_WRITE12 }; }
 
  constraint c_transmit_delay12 { transmit_delay12 <= 10 ; }

  `uvm_object_utils_begin(apb_transfer12)
    `uvm_field_int(addr, UVM_DEFAULT)
    `uvm_field_enum(apb_direction_enum12, direction12, UVM_DEFAULT)
    `uvm_field_int(data, UVM_DEFAULT)
    `uvm_field_string(master12, UVM_DEFAULT|UVM_NOCOMPARE)
    `uvm_field_string(slave12, UVM_DEFAULT|UVM_NOCOMPARE)
  `uvm_object_utils_end

  function new (string name = "apb_transfer12");
    super.new(name);
  endfunction

endclass : apb_transfer12

`endif // APB_TRANSFER_SV12
