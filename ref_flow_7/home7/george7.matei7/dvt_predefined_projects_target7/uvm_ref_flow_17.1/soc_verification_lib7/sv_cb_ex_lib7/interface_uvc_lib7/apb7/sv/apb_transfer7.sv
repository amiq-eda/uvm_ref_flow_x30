/*******************************************************************************
  FILE : apb_transfer7.svh
*******************************************************************************/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------


`ifndef APB_TRANSFER_SV7
`define APB_TRANSFER_SV7

//------------------------------------------------------------------------------
// CLASS7: apb_transfer7 declaration7
//------------------------------------------------------------------------------

class apb_transfer7 extends uvm_sequence_item;                                  

  rand bit [31:0]           addr;
  rand apb_direction_enum7   direction7;
  rand bit [31:0]           data;
  rand int unsigned         transmit_delay7 = 0;
  string                    master7 = "";
  string                    slave7 = "";
   
  constraint c_direction7 { direction7 inside { APB_READ7, APB_WRITE7 }; }
 
  constraint c_transmit_delay7 { transmit_delay7 <= 10 ; }

  `uvm_object_utils_begin(apb_transfer7)
    `uvm_field_int(addr, UVM_DEFAULT)
    `uvm_field_enum(apb_direction_enum7, direction7, UVM_DEFAULT)
    `uvm_field_int(data, UVM_DEFAULT)
    `uvm_field_string(master7, UVM_DEFAULT|UVM_NOCOMPARE)
    `uvm_field_string(slave7, UVM_DEFAULT|UVM_NOCOMPARE)
  `uvm_object_utils_end

  function new (string name = "apb_transfer7");
    super.new(name);
  endfunction

endclass : apb_transfer7

`endif // APB_TRANSFER_SV7
