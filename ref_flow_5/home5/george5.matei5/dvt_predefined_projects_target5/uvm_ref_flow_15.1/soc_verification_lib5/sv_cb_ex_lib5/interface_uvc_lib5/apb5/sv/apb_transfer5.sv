/*******************************************************************************
  FILE : apb_transfer5.svh
*******************************************************************************/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------


`ifndef APB_TRANSFER_SV5
`define APB_TRANSFER_SV5

//------------------------------------------------------------------------------
// CLASS5: apb_transfer5 declaration5
//------------------------------------------------------------------------------

class apb_transfer5 extends uvm_sequence_item;                                  

  rand bit [31:0]           addr;
  rand apb_direction_enum5   direction5;
  rand bit [31:0]           data;
  rand int unsigned         transmit_delay5 = 0;
  string                    master5 = "";
  string                    slave5 = "";
   
  constraint c_direction5 { direction5 inside { APB_READ5, APB_WRITE5 }; }
 
  constraint c_transmit_delay5 { transmit_delay5 <= 10 ; }

  `uvm_object_utils_begin(apb_transfer5)
    `uvm_field_int(addr, UVM_DEFAULT)
    `uvm_field_enum(apb_direction_enum5, direction5, UVM_DEFAULT)
    `uvm_field_int(data, UVM_DEFAULT)
    `uvm_field_string(master5, UVM_DEFAULT|UVM_NOCOMPARE)
    `uvm_field_string(slave5, UVM_DEFAULT|UVM_NOCOMPARE)
  `uvm_object_utils_end

  function new (string name = "apb_transfer5");
    super.new(name);
  endfunction

endclass : apb_transfer5

`endif // APB_TRANSFER_SV5
