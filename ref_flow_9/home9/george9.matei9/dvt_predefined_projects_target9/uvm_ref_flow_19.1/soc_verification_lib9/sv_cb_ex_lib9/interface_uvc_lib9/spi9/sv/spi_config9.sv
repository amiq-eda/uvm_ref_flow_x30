/*-------------------------------------------------------------------------
File9 name   : spi_config9.sv
Title9       : SPI9 environment9 configuration file
Project9     : UVM SystemVerilog9 Cluster9 Level9 Verification9
Created9     :
Description9 :
Notes9       :  
----------------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------


`ifndef SPI_CFG_SVH9
`define SPI_CFG_SVH9

class spi_config9 extends uvm_object;

  function new (string name = "");
    super.new(name);
  endfunction

  uvm_active_passive_enum  active_passive9 = UVM_ACTIVE;

  `uvm_object_utils_begin(spi_config9)
    `uvm_field_enum(uvm_active_passive_enum, active_passive9, UVM_ALL_ON)
   `uvm_object_utils_end

endclass

`endif

