/*-------------------------------------------------------------------------
File14 name   : spi_config14.sv
Title14       : SPI14 environment14 configuration file
Project14     : UVM SystemVerilog14 Cluster14 Level14 Verification14
Created14     :
Description14 :
Notes14       :  
----------------------------------------------------------------------*/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------


`ifndef SPI_CFG_SVH14
`define SPI_CFG_SVH14

class spi_config14 extends uvm_object;

  function new (string name = "");
    super.new(name);
  endfunction

  uvm_active_passive_enum  active_passive14 = UVM_ACTIVE;

  `uvm_object_utils_begin(spi_config14)
    `uvm_field_enum(uvm_active_passive_enum, active_passive14, UVM_ALL_ON)
   `uvm_object_utils_end

endclass

`endif

