/*******************************************************************************
  FILE : apb_transfer2.svh
*******************************************************************************/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------


`ifndef APB_TRANSFER_SV2
`define APB_TRANSFER_SV2

//------------------------------------------------------------------------------
// CLASS2: apb_transfer2 declaration2
//------------------------------------------------------------------------------

class apb_transfer2 extends uvm_sequence_item;                                  

  rand bit [31:0]           addr;
  rand apb_direction_enum2   direction2;
  rand bit [31:0]           data;
  rand int unsigned         transmit_delay2 = 0;
  string                    master2 = "";
  string                    slave2 = "";
   
  constraint c_direction2 { direction2 inside { APB_READ2, APB_WRITE2 }; }
 
  constraint c_transmit_delay2 { transmit_delay2 <= 10 ; }

  `uvm_object_utils_begin(apb_transfer2)
    `uvm_field_int(addr, UVM_DEFAULT)
    `uvm_field_enum(apb_direction_enum2, direction2, UVM_DEFAULT)
    `uvm_field_int(data, UVM_DEFAULT)
    `uvm_field_string(master2, UVM_DEFAULT|UVM_NOCOMPARE)
    `uvm_field_string(slave2, UVM_DEFAULT|UVM_NOCOMPARE)
  `uvm_object_utils_end

  function new (string name = "apb_transfer2");
    super.new(name);
  endfunction

endclass : apb_transfer2

`endif // APB_TRANSFER_SV2
