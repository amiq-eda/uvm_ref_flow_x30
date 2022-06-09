/*-------------------------------------------------------------------------
File2 name   : gpio_config2.sv
Title2       : gpio2 environment2 configuration file
Project2     : UVM SystemVerilog2 Cluster2 Level2 Verification2
Created2     :
Description2 :
Notes2       :  
----------------------------------------------------------------------*/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------


`ifndef GPIO_CFG_SVH2
`define GPIO_CFG_SVH2

class gpio_config2 extends uvm_object;

  function new (string name = "");
    super.new(name);
  endfunction

  uvm_active_passive_enum  active_passive2 = UVM_ACTIVE;

  `uvm_object_utils_begin(gpio_config2)
    `uvm_field_enum(uvm_active_passive_enum, active_passive2, UVM_ALL_ON)
   `uvm_object_utils_end

endclass

`endif

