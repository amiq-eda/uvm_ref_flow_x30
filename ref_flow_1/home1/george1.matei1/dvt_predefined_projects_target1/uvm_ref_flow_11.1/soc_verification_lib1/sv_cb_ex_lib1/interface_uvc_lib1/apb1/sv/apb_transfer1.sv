/*******************************************************************************
  FILE : apb_transfer1.svh
*******************************************************************************/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------


`ifndef APB_TRANSFER_SV1
`define APB_TRANSFER_SV1

//------------------------------------------------------------------------------
// CLASS1: apb_transfer1 declaration1
//------------------------------------------------------------------------------

class apb_transfer1 extends uvm_sequence_item;                                  

  rand bit [31:0]           addr;
  rand apb_direction_enum1   direction1;
  rand bit [31:0]           data;
  rand int unsigned         transmit_delay1 = 0;
  string                    master1 = "";
  string                    slave1 = "";
   
  constraint c_direction1 { direction1 inside { APB_READ1, APB_WRITE1 }; }
 
  constraint c_transmit_delay1 { transmit_delay1 <= 10 ; }

  `uvm_object_utils_begin(apb_transfer1)
    `uvm_field_int(addr, UVM_DEFAULT)
    `uvm_field_enum(apb_direction_enum1, direction1, UVM_DEFAULT)
    `uvm_field_int(data, UVM_DEFAULT)
    `uvm_field_string(master1, UVM_DEFAULT|UVM_NOCOMPARE)
    `uvm_field_string(slave1, UVM_DEFAULT|UVM_NOCOMPARE)
  `uvm_object_utils_end

  function new (string name = "apb_transfer1");
    super.new(name);
  endfunction

endclass : apb_transfer1

`endif // APB_TRANSFER_SV1
