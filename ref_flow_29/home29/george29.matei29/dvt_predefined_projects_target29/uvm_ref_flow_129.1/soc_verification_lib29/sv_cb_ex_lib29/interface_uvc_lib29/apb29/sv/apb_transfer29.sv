/*******************************************************************************
  FILE : apb_transfer29.svh
*******************************************************************************/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------


`ifndef APB_TRANSFER_SV29
`define APB_TRANSFER_SV29

//------------------------------------------------------------------------------
// CLASS29: apb_transfer29 declaration29
//------------------------------------------------------------------------------

class apb_transfer29 extends uvm_sequence_item;                                  

  rand bit [31:0]           addr;
  rand apb_direction_enum29   direction29;
  rand bit [31:0]           data;
  rand int unsigned         transmit_delay29 = 0;
  string                    master29 = "";
  string                    slave29 = "";
   
  constraint c_direction29 { direction29 inside { APB_READ29, APB_WRITE29 }; }
 
  constraint c_transmit_delay29 { transmit_delay29 <= 10 ; }

  `uvm_object_utils_begin(apb_transfer29)
    `uvm_field_int(addr, UVM_DEFAULT)
    `uvm_field_enum(apb_direction_enum29, direction29, UVM_DEFAULT)
    `uvm_field_int(data, UVM_DEFAULT)
    `uvm_field_string(master29, UVM_DEFAULT|UVM_NOCOMPARE)
    `uvm_field_string(slave29, UVM_DEFAULT|UVM_NOCOMPARE)
  `uvm_object_utils_end

  function new (string name = "apb_transfer29");
    super.new(name);
  endfunction

endclass : apb_transfer29

`endif // APB_TRANSFER_SV29
