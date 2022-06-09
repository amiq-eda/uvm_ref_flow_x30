/*-------------------------------------------------------------------------
File23 name   : spi_config23.sv
Title23       : SPI23 environment23 configuration file
Project23     : UVM SystemVerilog23 Cluster23 Level23 Verification23
Created23     :
Description23 :
Notes23       :  
----------------------------------------------------------------------*/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------


`ifndef SPI_CFG_SVH23
`define SPI_CFG_SVH23

class spi_config23 extends uvm_object;

  function new (string name = "");
    super.new(name);
  endfunction

  uvm_active_passive_enum  active_passive23 = UVM_ACTIVE;

  `uvm_object_utils_begin(spi_config23)
    `uvm_field_enum(uvm_active_passive_enum, active_passive23, UVM_ALL_ON)
   `uvm_object_utils_end

endclass

`endif

