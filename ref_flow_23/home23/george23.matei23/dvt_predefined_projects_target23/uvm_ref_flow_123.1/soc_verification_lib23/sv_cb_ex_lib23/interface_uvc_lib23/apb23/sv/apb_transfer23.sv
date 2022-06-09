/*******************************************************************************
  FILE : apb_transfer23.svh
*******************************************************************************/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------


`ifndef APB_TRANSFER_SV23
`define APB_TRANSFER_SV23

//------------------------------------------------------------------------------
// CLASS23: apb_transfer23 declaration23
//------------------------------------------------------------------------------

class apb_transfer23 extends uvm_sequence_item;                                  

  rand bit [31:0]           addr;
  rand apb_direction_enum23   direction23;
  rand bit [31:0]           data;
  rand int unsigned         transmit_delay23 = 0;
  string                    master23 = "";
  string                    slave23 = "";
   
  constraint c_direction23 { direction23 inside { APB_READ23, APB_WRITE23 }; }
 
  constraint c_transmit_delay23 { transmit_delay23 <= 10 ; }

  `uvm_object_utils_begin(apb_transfer23)
    `uvm_field_int(addr, UVM_DEFAULT)
    `uvm_field_enum(apb_direction_enum23, direction23, UVM_DEFAULT)
    `uvm_field_int(data, UVM_DEFAULT)
    `uvm_field_string(master23, UVM_DEFAULT|UVM_NOCOMPARE)
    `uvm_field_string(slave23, UVM_DEFAULT|UVM_NOCOMPARE)
  `uvm_object_utils_end

  function new (string name = "apb_transfer23");
    super.new(name);
  endfunction

endclass : apb_transfer23

`endif // APB_TRANSFER_SV23
