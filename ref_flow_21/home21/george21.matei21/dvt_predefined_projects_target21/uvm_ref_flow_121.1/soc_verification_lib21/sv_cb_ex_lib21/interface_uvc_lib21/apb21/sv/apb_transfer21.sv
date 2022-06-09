/*******************************************************************************
  FILE : apb_transfer21.svh
*******************************************************************************/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------


`ifndef APB_TRANSFER_SV21
`define APB_TRANSFER_SV21

//------------------------------------------------------------------------------
// CLASS21: apb_transfer21 declaration21
//------------------------------------------------------------------------------

class apb_transfer21 extends uvm_sequence_item;                                  

  rand bit [31:0]           addr;
  rand apb_direction_enum21   direction21;
  rand bit [31:0]           data;
  rand int unsigned         transmit_delay21 = 0;
  string                    master21 = "";
  string                    slave21 = "";
   
  constraint c_direction21 { direction21 inside { APB_READ21, APB_WRITE21 }; }
 
  constraint c_transmit_delay21 { transmit_delay21 <= 10 ; }

  `uvm_object_utils_begin(apb_transfer21)
    `uvm_field_int(addr, UVM_DEFAULT)
    `uvm_field_enum(apb_direction_enum21, direction21, UVM_DEFAULT)
    `uvm_field_int(data, UVM_DEFAULT)
    `uvm_field_string(master21, UVM_DEFAULT|UVM_NOCOMPARE)
    `uvm_field_string(slave21, UVM_DEFAULT|UVM_NOCOMPARE)
  `uvm_object_utils_end

  function new (string name = "apb_transfer21");
    super.new(name);
  endfunction

endclass : apb_transfer21

`endif // APB_TRANSFER_SV21
