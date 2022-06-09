/*-------------------------------------------------------------------------
File10 name   : spi_config10.sv
Title10       : SPI10 environment10 configuration file
Project10     : UVM SystemVerilog10 Cluster10 Level10 Verification10
Created10     :
Description10 :
Notes10       :  
----------------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------


`ifndef SPI_CFG_SVH10
`define SPI_CFG_SVH10

class spi_config10 extends uvm_object;

  function new (string name = "");
    super.new(name);
  endfunction

  uvm_active_passive_enum  active_passive10 = UVM_ACTIVE;

  `uvm_object_utils_begin(spi_config10)
    `uvm_field_enum(uvm_active_passive_enum, active_passive10, UVM_ALL_ON)
   `uvm_object_utils_end

endclass

`endif

