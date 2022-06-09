/*-------------------------------------------------------------------------
File28 name   : spi_config28.sv
Title28       : SPI28 environment28 configuration file
Project28     : UVM SystemVerilog28 Cluster28 Level28 Verification28
Created28     :
Description28 :
Notes28       :  
----------------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------


`ifndef SPI_CFG_SVH28
`define SPI_CFG_SVH28

class spi_config28 extends uvm_object;

  function new (string name = "");
    super.new(name);
  endfunction

  uvm_active_passive_enum  active_passive28 = UVM_ACTIVE;

  `uvm_object_utils_begin(spi_config28)
    `uvm_field_enum(uvm_active_passive_enum, active_passive28, UVM_ALL_ON)
   `uvm_object_utils_end

endclass

`endif

