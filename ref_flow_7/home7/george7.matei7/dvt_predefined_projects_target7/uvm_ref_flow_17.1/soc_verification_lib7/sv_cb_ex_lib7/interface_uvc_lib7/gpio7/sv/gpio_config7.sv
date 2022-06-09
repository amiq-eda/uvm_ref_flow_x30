/*-------------------------------------------------------------------------
File7 name   : gpio_config7.sv
Title7       : gpio7 environment7 configuration file
Project7     : UVM SystemVerilog7 Cluster7 Level7 Verification7
Created7     :
Description7 :
Notes7       :  
----------------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------


`ifndef GPIO_CFG_SVH7
`define GPIO_CFG_SVH7

class gpio_config7 extends uvm_object;

  function new (string name = "");
    super.new(name);
  endfunction

  uvm_active_passive_enum  active_passive7 = UVM_ACTIVE;

  `uvm_object_utils_begin(gpio_config7)
    `uvm_field_enum(uvm_active_passive_enum, active_passive7, UVM_ALL_ON)
   `uvm_object_utils_end

endclass

`endif

