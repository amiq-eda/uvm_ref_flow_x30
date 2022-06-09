/*-------------------------------------------------------------------------
File27 name   : gpio_config27.sv
Title27       : gpio27 environment27 configuration file
Project27     : UVM SystemVerilog27 Cluster27 Level27 Verification27
Created27     :
Description27 :
Notes27       :  
----------------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


`ifndef GPIO_CFG_SVH27
`define GPIO_CFG_SVH27

class gpio_config27 extends uvm_object;

  function new (string name = "");
    super.new(name);
  endfunction

  uvm_active_passive_enum  active_passive27 = UVM_ACTIVE;

  `uvm_object_utils_begin(gpio_config27)
    `uvm_field_enum(uvm_active_passive_enum, active_passive27, UVM_ALL_ON)
   `uvm_object_utils_end

endclass

`endif

