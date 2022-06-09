/*-------------------------------------------------------------------------
File13 name   : gpio_config13.sv
Title13       : gpio13 environment13 configuration file
Project13     : UVM SystemVerilog13 Cluster13 Level13 Verification13
Created13     :
Description13 :
Notes13       :  
----------------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------


`ifndef GPIO_CFG_SVH13
`define GPIO_CFG_SVH13

class gpio_config13 extends uvm_object;

  function new (string name = "");
    super.new(name);
  endfunction

  uvm_active_passive_enum  active_passive13 = UVM_ACTIVE;

  `uvm_object_utils_begin(gpio_config13)
    `uvm_field_enum(uvm_active_passive_enum, active_passive13, UVM_ALL_ON)
   `uvm_object_utils_end

endclass

`endif

