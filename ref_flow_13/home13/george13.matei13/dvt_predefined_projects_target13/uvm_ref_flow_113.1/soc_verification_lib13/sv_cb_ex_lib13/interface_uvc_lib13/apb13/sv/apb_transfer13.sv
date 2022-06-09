/*******************************************************************************
  FILE : apb_transfer13.svh
*******************************************************************************/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------


`ifndef APB_TRANSFER_SV13
`define APB_TRANSFER_SV13

//------------------------------------------------------------------------------
// CLASS13: apb_transfer13 declaration13
//------------------------------------------------------------------------------

class apb_transfer13 extends uvm_sequence_item;                                  

  rand bit [31:0]           addr;
  rand apb_direction_enum13   direction13;
  rand bit [31:0]           data;
  rand int unsigned         transmit_delay13 = 0;
  string                    master13 = "";
  string                    slave13 = "";
   
  constraint c_direction13 { direction13 inside { APB_READ13, APB_WRITE13 }; }
 
  constraint c_transmit_delay13 { transmit_delay13 <= 10 ; }

  `uvm_object_utils_begin(apb_transfer13)
    `uvm_field_int(addr, UVM_DEFAULT)
    `uvm_field_enum(apb_direction_enum13, direction13, UVM_DEFAULT)
    `uvm_field_int(data, UVM_DEFAULT)
    `uvm_field_string(master13, UVM_DEFAULT|UVM_NOCOMPARE)
    `uvm_field_string(slave13, UVM_DEFAULT|UVM_NOCOMPARE)
  `uvm_object_utils_end

  function new (string name = "apb_transfer13");
    super.new(name);
  endfunction

endclass : apb_transfer13

`endif // APB_TRANSFER_SV13
