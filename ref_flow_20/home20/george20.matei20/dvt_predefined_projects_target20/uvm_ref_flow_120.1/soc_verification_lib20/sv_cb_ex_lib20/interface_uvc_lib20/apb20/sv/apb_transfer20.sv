/*******************************************************************************
  FILE : apb_transfer20.svh
*******************************************************************************/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------


`ifndef APB_TRANSFER_SV20
`define APB_TRANSFER_SV20

//------------------------------------------------------------------------------
// CLASS20: apb_transfer20 declaration20
//------------------------------------------------------------------------------

class apb_transfer20 extends uvm_sequence_item;                                  

  rand bit [31:0]           addr;
  rand apb_direction_enum20   direction20;
  rand bit [31:0]           data;
  rand int unsigned         transmit_delay20 = 0;
  string                    master20 = "";
  string                    slave20 = "";
   
  constraint c_direction20 { direction20 inside { APB_READ20, APB_WRITE20 }; }
 
  constraint c_transmit_delay20 { transmit_delay20 <= 10 ; }

  `uvm_object_utils_begin(apb_transfer20)
    `uvm_field_int(addr, UVM_DEFAULT)
    `uvm_field_enum(apb_direction_enum20, direction20, UVM_DEFAULT)
    `uvm_field_int(data, UVM_DEFAULT)
    `uvm_field_string(master20, UVM_DEFAULT|UVM_NOCOMPARE)
    `uvm_field_string(slave20, UVM_DEFAULT|UVM_NOCOMPARE)
  `uvm_object_utils_end

  function new (string name = "apb_transfer20");
    super.new(name);
  endfunction

endclass : apb_transfer20

`endif // APB_TRANSFER_SV20
