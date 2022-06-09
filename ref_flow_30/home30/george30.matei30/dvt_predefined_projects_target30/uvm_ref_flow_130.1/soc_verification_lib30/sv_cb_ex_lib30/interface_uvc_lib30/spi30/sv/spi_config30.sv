/*-------------------------------------------------------------------------
File30 name   : spi_config30.sv
Title30       : SPI30 environment30 configuration file
Project30     : UVM SystemVerilog30 Cluster30 Level30 Verification30
Created30     :
Description30 :
Notes30       :  
----------------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


`ifndef SPI_CFG_SVH30
`define SPI_CFG_SVH30

class spi_config30 extends uvm_object;

  function new (string name = "");
    super.new(name);
  endfunction

  uvm_active_passive_enum  active_passive30 = UVM_ACTIVE;

  `uvm_object_utils_begin(spi_config30)
    `uvm_field_enum(uvm_active_passive_enum, active_passive30, UVM_ALL_ON)
   `uvm_object_utils_end

endclass

`endif

