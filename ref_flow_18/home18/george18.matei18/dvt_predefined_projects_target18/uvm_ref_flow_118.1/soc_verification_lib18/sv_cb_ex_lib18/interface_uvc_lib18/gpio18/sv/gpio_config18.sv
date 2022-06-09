/*-------------------------------------------------------------------------
File18 name   : gpio_config18.sv
Title18       : gpio18 environment18 configuration file
Project18     : UVM SystemVerilog18 Cluster18 Level18 Verification18
Created18     :
Description18 :
Notes18       :  
----------------------------------------------------------------------*/
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


`ifndef GPIO_CFG_SVH18
`define GPIO_CFG_SVH18

class gpio_config18 extends uvm_object;

  function new (string name = "");
    super.new(name);
  endfunction

  uvm_active_passive_enum  active_passive18 = UVM_ACTIVE;

  `uvm_object_utils_begin(gpio_config18)
    `uvm_field_enum(uvm_active_passive_enum, active_passive18, UVM_ALL_ON)
   `uvm_object_utils_end

endclass

`endif

