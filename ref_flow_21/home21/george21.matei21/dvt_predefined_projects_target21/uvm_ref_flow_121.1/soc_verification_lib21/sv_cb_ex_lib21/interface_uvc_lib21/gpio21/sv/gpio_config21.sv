/*-------------------------------------------------------------------------
File21 name   : gpio_config21.sv
Title21       : gpio21 environment21 configuration file
Project21     : UVM SystemVerilog21 Cluster21 Level21 Verification21
Created21     :
Description21 :
Notes21       :  
----------------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------


`ifndef GPIO_CFG_SVH21
`define GPIO_CFG_SVH21

class gpio_config21 extends uvm_object;

  function new (string name = "");
    super.new(name);
  endfunction

  uvm_active_passive_enum  active_passive21 = UVM_ACTIVE;

  `uvm_object_utils_begin(gpio_config21)
    `uvm_field_enum(uvm_active_passive_enum, active_passive21, UVM_ALL_ON)
   `uvm_object_utils_end

endclass

`endif

