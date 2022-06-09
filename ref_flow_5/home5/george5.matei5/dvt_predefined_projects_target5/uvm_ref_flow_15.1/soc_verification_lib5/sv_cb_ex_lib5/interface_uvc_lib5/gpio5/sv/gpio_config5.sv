/*-------------------------------------------------------------------------
File5 name   : gpio_config5.sv
Title5       : gpio5 environment5 configuration file
Project5     : UVM SystemVerilog5 Cluster5 Level5 Verification5
Created5     :
Description5 :
Notes5       :  
----------------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------


`ifndef GPIO_CFG_SVH5
`define GPIO_CFG_SVH5

class gpio_config5 extends uvm_object;

  function new (string name = "");
    super.new(name);
  endfunction

  uvm_active_passive_enum  active_passive5 = UVM_ACTIVE;

  `uvm_object_utils_begin(gpio_config5)
    `uvm_field_enum(uvm_active_passive_enum, active_passive5, UVM_ALL_ON)
   `uvm_object_utils_end

endclass

`endif

