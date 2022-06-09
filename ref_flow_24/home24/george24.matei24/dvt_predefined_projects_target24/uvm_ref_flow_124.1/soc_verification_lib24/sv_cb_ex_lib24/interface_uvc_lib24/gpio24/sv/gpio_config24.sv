/*-------------------------------------------------------------------------
File24 name   : gpio_config24.sv
Title24       : gpio24 environment24 configuration file
Project24     : UVM SystemVerilog24 Cluster24 Level24 Verification24
Created24     :
Description24 :
Notes24       :  
----------------------------------------------------------------------*/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------


`ifndef GPIO_CFG_SVH24
`define GPIO_CFG_SVH24

class gpio_config24 extends uvm_object;

  function new (string name = "");
    super.new(name);
  endfunction

  uvm_active_passive_enum  active_passive24 = UVM_ACTIVE;

  `uvm_object_utils_begin(gpio_config24)
    `uvm_field_enum(uvm_active_passive_enum, active_passive24, UVM_ALL_ON)
   `uvm_object_utils_end

endclass

`endif

