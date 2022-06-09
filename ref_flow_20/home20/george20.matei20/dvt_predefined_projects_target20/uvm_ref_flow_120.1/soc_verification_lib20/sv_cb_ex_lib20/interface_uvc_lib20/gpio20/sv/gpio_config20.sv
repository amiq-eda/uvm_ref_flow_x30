/*-------------------------------------------------------------------------
File20 name   : gpio_config20.sv
Title20       : gpio20 environment20 configuration file
Project20     : UVM SystemVerilog20 Cluster20 Level20 Verification20
Created20     :
Description20 :
Notes20       :  
----------------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------


`ifndef GPIO_CFG_SVH20
`define GPIO_CFG_SVH20

class gpio_config20 extends uvm_object;

  function new (string name = "");
    super.new(name);
  endfunction

  uvm_active_passive_enum  active_passive20 = UVM_ACTIVE;

  `uvm_object_utils_begin(gpio_config20)
    `uvm_field_enum(uvm_active_passive_enum, active_passive20, UVM_ALL_ON)
   `uvm_object_utils_end

endclass

`endif

