/*******************************************************************************
  FILE : apb_transfer6.svh
*******************************************************************************/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------


`ifndef APB_TRANSFER_SV6
`define APB_TRANSFER_SV6

//------------------------------------------------------------------------------
// CLASS6: apb_transfer6 declaration6
//------------------------------------------------------------------------------

class apb_transfer6 extends uvm_sequence_item;                                  

  rand bit [31:0]           addr;
  rand apb_direction_enum6   direction6;
  rand bit [31:0]           data;
  rand int unsigned         transmit_delay6 = 0;
  string                    master6 = "";
  string                    slave6 = "";
   
  constraint c_direction6 { direction6 inside { APB_READ6, APB_WRITE6 }; }
 
  constraint c_transmit_delay6 { transmit_delay6 <= 10 ; }

  `uvm_object_utils_begin(apb_transfer6)
    `uvm_field_int(addr, UVM_DEFAULT)
    `uvm_field_enum(apb_direction_enum6, direction6, UVM_DEFAULT)
    `uvm_field_int(data, UVM_DEFAULT)
    `uvm_field_string(master6, UVM_DEFAULT|UVM_NOCOMPARE)
    `uvm_field_string(slave6, UVM_DEFAULT|UVM_NOCOMPARE)
  `uvm_object_utils_end

  function new (string name = "apb_transfer6");
    super.new(name);
  endfunction

endclass : apb_transfer6

`endif // APB_TRANSFER_SV6
