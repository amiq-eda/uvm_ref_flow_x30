/*-------------------------------------------------------------------------
File15 name   : gpio_config15.sv
Title15       : gpio15 environment15 configuration file
Project15     : UVM SystemVerilog15 Cluster15 Level15 Verification15
Created15     :
Description15 :
Notes15       :  
----------------------------------------------------------------------*/
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


`ifndef GPIO_CFG_SVH15
`define GPIO_CFG_SVH15

class gpio_config15 extends uvm_object;

  function new (string name = "");
    super.new(name);
  endfunction

  uvm_active_passive_enum  active_passive15 = UVM_ACTIVE;

  `uvm_object_utils_begin(gpio_config15)
    `uvm_field_enum(uvm_active_passive_enum, active_passive15, UVM_ALL_ON)
   `uvm_object_utils_end

endclass

`endif

