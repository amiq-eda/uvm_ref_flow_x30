/*-------------------------------------------------------------------------
File29 name   : gpio_config29.sv
Title29       : gpio29 environment29 configuration file
Project29     : UVM SystemVerilog29 Cluster29 Level29 Verification29
Created29     :
Description29 :
Notes29       :  
----------------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------


`ifndef GPIO_CFG_SVH29
`define GPIO_CFG_SVH29

class gpio_config29 extends uvm_object;

  function new (string name = "");
    super.new(name);
  endfunction

  uvm_active_passive_enum  active_passive29 = UVM_ACTIVE;

  `uvm_object_utils_begin(gpio_config29)
    `uvm_field_enum(uvm_active_passive_enum, active_passive29, UVM_ALL_ON)
   `uvm_object_utils_end

endclass

`endif

