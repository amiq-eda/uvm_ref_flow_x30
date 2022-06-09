/*-------------------------------------------------------------------------
File25 name   : spi_config25.sv
Title25       : SPI25 environment25 configuration file
Project25     : UVM SystemVerilog25 Cluster25 Level25 Verification25
Created25     :
Description25 :
Notes25       :  
----------------------------------------------------------------------*/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------


`ifndef SPI_CFG_SVH25
`define SPI_CFG_SVH25

class spi_config25 extends uvm_object;

  function new (string name = "");
    super.new(name);
  endfunction

  uvm_active_passive_enum  active_passive25 = UVM_ACTIVE;

  `uvm_object_utils_begin(spi_config25)
    `uvm_field_enum(uvm_active_passive_enum, active_passive25, UVM_ALL_ON)
   `uvm_object_utils_end

endclass

`endif

