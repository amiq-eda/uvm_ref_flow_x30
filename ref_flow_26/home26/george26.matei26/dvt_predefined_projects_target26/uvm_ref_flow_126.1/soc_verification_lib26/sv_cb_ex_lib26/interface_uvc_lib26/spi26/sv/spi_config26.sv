/*-------------------------------------------------------------------------
File26 name   : spi_config26.sv
Title26       : SPI26 environment26 configuration file
Project26     : UVM SystemVerilog26 Cluster26 Level26 Verification26
Created26     :
Description26 :
Notes26       :  
----------------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


`ifndef SPI_CFG_SVH26
`define SPI_CFG_SVH26

class spi_config26 extends uvm_object;

  function new (string name = "");
    super.new(name);
  endfunction

  uvm_active_passive_enum  active_passive26 = UVM_ACTIVE;

  `uvm_object_utils_begin(spi_config26)
    `uvm_field_enum(uvm_active_passive_enum, active_passive26, UVM_ALL_ON)
   `uvm_object_utils_end

endclass

`endif

