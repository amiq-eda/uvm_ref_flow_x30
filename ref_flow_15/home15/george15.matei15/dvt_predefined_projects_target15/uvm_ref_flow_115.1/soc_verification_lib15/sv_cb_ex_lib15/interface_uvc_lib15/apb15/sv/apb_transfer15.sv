/*******************************************************************************
  FILE : apb_transfer15.svh
*******************************************************************************/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------


`ifndef APB_TRANSFER_SV15
`define APB_TRANSFER_SV15

//------------------------------------------------------------------------------
// CLASS15: apb_transfer15 declaration15
//------------------------------------------------------------------------------

class apb_transfer15 extends uvm_sequence_item;                                  

  rand bit [31:0]           addr;
  rand apb_direction_enum15   direction15;
  rand bit [31:0]           data;
  rand int unsigned         transmit_delay15 = 0;
  string                    master15 = "";
  string                    slave15 = "";
   
  constraint c_direction15 { direction15 inside { APB_READ15, APB_WRITE15 }; }
 
  constraint c_transmit_delay15 { transmit_delay15 <= 10 ; }

  `uvm_object_utils_begin(apb_transfer15)
    `uvm_field_int(addr, UVM_DEFAULT)
    `uvm_field_enum(apb_direction_enum15, direction15, UVM_DEFAULT)
    `uvm_field_int(data, UVM_DEFAULT)
    `uvm_field_string(master15, UVM_DEFAULT|UVM_NOCOMPARE)
    `uvm_field_string(slave15, UVM_DEFAULT|UVM_NOCOMPARE)
  `uvm_object_utils_end

  function new (string name = "apb_transfer15");
    super.new(name);
  endfunction

endclass : apb_transfer15

`endif // APB_TRANSFER_SV15
