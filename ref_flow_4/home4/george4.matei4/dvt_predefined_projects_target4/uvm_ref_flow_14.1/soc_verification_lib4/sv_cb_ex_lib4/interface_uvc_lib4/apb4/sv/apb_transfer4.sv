/*******************************************************************************
  FILE : apb_transfer4.svh
*******************************************************************************/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------


`ifndef APB_TRANSFER_SV4
`define APB_TRANSFER_SV4

//------------------------------------------------------------------------------
// CLASS4: apb_transfer4 declaration4
//------------------------------------------------------------------------------

class apb_transfer4 extends uvm_sequence_item;                                  

  rand bit [31:0]           addr;
  rand apb_direction_enum4   direction4;
  rand bit [31:0]           data;
  rand int unsigned         transmit_delay4 = 0;
  string                    master4 = "";
  string                    slave4 = "";
   
  constraint c_direction4 { direction4 inside { APB_READ4, APB_WRITE4 }; }
 
  constraint c_transmit_delay4 { transmit_delay4 <= 10 ; }

  `uvm_object_utils_begin(apb_transfer4)
    `uvm_field_int(addr, UVM_DEFAULT)
    `uvm_field_enum(apb_direction_enum4, direction4, UVM_DEFAULT)
    `uvm_field_int(data, UVM_DEFAULT)
    `uvm_field_string(master4, UVM_DEFAULT|UVM_NOCOMPARE)
    `uvm_field_string(slave4, UVM_DEFAULT|UVM_NOCOMPARE)
  `uvm_object_utils_end

  function new (string name = "apb_transfer4");
    super.new(name);
  endfunction

endclass : apb_transfer4

`endif // APB_TRANSFER_SV4
