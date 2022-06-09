/*******************************************************************************
  FILE : apb_transfer3.svh
*******************************************************************************/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------


`ifndef APB_TRANSFER_SV3
`define APB_TRANSFER_SV3

//------------------------------------------------------------------------------
// CLASS3: apb_transfer3 declaration3
//------------------------------------------------------------------------------

class apb_transfer3 extends uvm_sequence_item;                                  

  rand bit [31:0]           addr;
  rand apb_direction_enum3   direction3;
  rand bit [31:0]           data;
  rand int unsigned         transmit_delay3 = 0;
  string                    master3 = "";
  string                    slave3 = "";
   
  constraint c_direction3 { direction3 inside { APB_READ3, APB_WRITE3 }; }
 
  constraint c_transmit_delay3 { transmit_delay3 <= 10 ; }

  `uvm_object_utils_begin(apb_transfer3)
    `uvm_field_int(addr, UVM_DEFAULT)
    `uvm_field_enum(apb_direction_enum3, direction3, UVM_DEFAULT)
    `uvm_field_int(data, UVM_DEFAULT)
    `uvm_field_string(master3, UVM_DEFAULT|UVM_NOCOMPARE)
    `uvm_field_string(slave3, UVM_DEFAULT|UVM_NOCOMPARE)
  `uvm_object_utils_end

  function new (string name = "apb_transfer3");
    super.new(name);
  endfunction

endclass : apb_transfer3

`endif // APB_TRANSFER_SV3
