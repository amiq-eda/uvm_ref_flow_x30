/*-------------------------------------------------------------------------
File22 name   : gpio_config22.sv
Title22       : gpio22 environment22 configuration file
Project22     : UVM SystemVerilog22 Cluster22 Level22 Verification22
Created22     :
Description22 :
Notes22       :  
----------------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------


`ifndef GPIO_CFG_SVH22
`define GPIO_CFG_SVH22

class gpio_config22 extends uvm_object;

  function new (string name = "");
    super.new(name);
  endfunction

  uvm_active_passive_enum  active_passive22 = UVM_ACTIVE;

  `uvm_object_utils_begin(gpio_config22)
    `uvm_field_enum(uvm_active_passive_enum, active_passive22, UVM_ALL_ON)
   `uvm_object_utils_end

endclass

`endif

