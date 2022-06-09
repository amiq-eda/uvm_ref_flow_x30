/*******************************************************************************
  FILE : apb_transfer18.svh
*******************************************************************************/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------


`ifndef APB_TRANSFER_SV18
`define APB_TRANSFER_SV18

//------------------------------------------------------------------------------
// CLASS18: apb_transfer18 declaration18
//------------------------------------------------------------------------------

class apb_transfer18 extends uvm_sequence_item;                                  

  rand bit [31:0]           addr;
  rand apb_direction_enum18   direction18;
  rand bit [31:0]           data;
  rand int unsigned         transmit_delay18 = 0;
  string                    master18 = "";
  string                    slave18 = "";
   
  constraint c_direction18 { direction18 inside { APB_READ18, APB_WRITE18 }; }
 
  constraint c_transmit_delay18 { transmit_delay18 <= 10 ; }

  `uvm_object_utils_begin(apb_transfer18)
    `uvm_field_int(addr, UVM_DEFAULT)
    `uvm_field_enum(apb_direction_enum18, direction18, UVM_DEFAULT)
    `uvm_field_int(data, UVM_DEFAULT)
    `uvm_field_string(master18, UVM_DEFAULT|UVM_NOCOMPARE)
    `uvm_field_string(slave18, UVM_DEFAULT|UVM_NOCOMPARE)
  `uvm_object_utils_end

  function new (string name = "apb_transfer18");
    super.new(name);
  endfunction

endclass : apb_transfer18

`endif // APB_TRANSFER_SV18
