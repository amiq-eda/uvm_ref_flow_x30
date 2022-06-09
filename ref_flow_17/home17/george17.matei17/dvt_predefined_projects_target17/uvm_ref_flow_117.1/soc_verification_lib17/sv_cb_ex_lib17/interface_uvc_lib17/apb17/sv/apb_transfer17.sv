/*******************************************************************************
  FILE : apb_transfer17.svh
*******************************************************************************/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------


`ifndef APB_TRANSFER_SV17
`define APB_TRANSFER_SV17

//------------------------------------------------------------------------------
// CLASS17: apb_transfer17 declaration17
//------------------------------------------------------------------------------

class apb_transfer17 extends uvm_sequence_item;                                  

  rand bit [31:0]           addr;
  rand apb_direction_enum17   direction17;
  rand bit [31:0]           data;
  rand int unsigned         transmit_delay17 = 0;
  string                    master17 = "";
  string                    slave17 = "";
   
  constraint c_direction17 { direction17 inside { APB_READ17, APB_WRITE17 }; }
 
  constraint c_transmit_delay17 { transmit_delay17 <= 10 ; }

  `uvm_object_utils_begin(apb_transfer17)
    `uvm_field_int(addr, UVM_DEFAULT)
    `uvm_field_enum(apb_direction_enum17, direction17, UVM_DEFAULT)
    `uvm_field_int(data, UVM_DEFAULT)
    `uvm_field_string(master17, UVM_DEFAULT|UVM_NOCOMPARE)
    `uvm_field_string(slave17, UVM_DEFAULT|UVM_NOCOMPARE)
  `uvm_object_utils_end

  function new (string name = "apb_transfer17");
    super.new(name);
  endfunction

endclass : apb_transfer17

`endif // APB_TRANSFER_SV17
