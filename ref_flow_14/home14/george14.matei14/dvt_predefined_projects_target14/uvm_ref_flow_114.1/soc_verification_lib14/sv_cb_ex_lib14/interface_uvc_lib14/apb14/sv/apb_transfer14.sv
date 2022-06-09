/*******************************************************************************
  FILE : apb_transfer14.svh
*******************************************************************************/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------


`ifndef APB_TRANSFER_SV14
`define APB_TRANSFER_SV14

//------------------------------------------------------------------------------
// CLASS14: apb_transfer14 declaration14
//------------------------------------------------------------------------------

class apb_transfer14 extends uvm_sequence_item;                                  

  rand bit [31:0]           addr;
  rand apb_direction_enum14   direction14;
  rand bit [31:0]           data;
  rand int unsigned         transmit_delay14 = 0;
  string                    master14 = "";
  string                    slave14 = "";
   
  constraint c_direction14 { direction14 inside { APB_READ14, APB_WRITE14 }; }
 
  constraint c_transmit_delay14 { transmit_delay14 <= 10 ; }

  `uvm_object_utils_begin(apb_transfer14)
    `uvm_field_int(addr, UVM_DEFAULT)
    `uvm_field_enum(apb_direction_enum14, direction14, UVM_DEFAULT)
    `uvm_field_int(data, UVM_DEFAULT)
    `uvm_field_string(master14, UVM_DEFAULT|UVM_NOCOMPARE)
    `uvm_field_string(slave14, UVM_DEFAULT|UVM_NOCOMPARE)
  `uvm_object_utils_end

  function new (string name = "apb_transfer14");
    super.new(name);
  endfunction

endclass : apb_transfer14

`endif // APB_TRANSFER_SV14
