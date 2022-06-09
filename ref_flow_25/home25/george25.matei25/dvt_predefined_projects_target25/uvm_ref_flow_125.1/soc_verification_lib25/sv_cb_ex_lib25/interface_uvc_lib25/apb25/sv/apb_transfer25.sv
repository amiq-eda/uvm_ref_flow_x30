/*******************************************************************************
  FILE : apb_transfer25.svh
*******************************************************************************/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------


`ifndef APB_TRANSFER_SV25
`define APB_TRANSFER_SV25

//------------------------------------------------------------------------------
// CLASS25: apb_transfer25 declaration25
//------------------------------------------------------------------------------

class apb_transfer25 extends uvm_sequence_item;                                  

  rand bit [31:0]           addr;
  rand apb_direction_enum25   direction25;
  rand bit [31:0]           data;
  rand int unsigned         transmit_delay25 = 0;
  string                    master25 = "";
  string                    slave25 = "";
   
  constraint c_direction25 { direction25 inside { APB_READ25, APB_WRITE25 }; }
 
  constraint c_transmit_delay25 { transmit_delay25 <= 10 ; }

  `uvm_object_utils_begin(apb_transfer25)
    `uvm_field_int(addr, UVM_DEFAULT)
    `uvm_field_enum(apb_direction_enum25, direction25, UVM_DEFAULT)
    `uvm_field_int(data, UVM_DEFAULT)
    `uvm_field_string(master25, UVM_DEFAULT|UVM_NOCOMPARE)
    `uvm_field_string(slave25, UVM_DEFAULT|UVM_NOCOMPARE)
  `uvm_object_utils_end

  function new (string name = "apb_transfer25");
    super.new(name);
  endfunction

endclass : apb_transfer25

`endif // APB_TRANSFER_SV25
