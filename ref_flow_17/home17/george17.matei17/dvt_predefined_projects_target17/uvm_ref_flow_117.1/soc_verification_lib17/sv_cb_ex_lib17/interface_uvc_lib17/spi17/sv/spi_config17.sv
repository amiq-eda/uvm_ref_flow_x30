/*-------------------------------------------------------------------------
File17 name   : spi_config17.sv
Title17       : SPI17 environment17 configuration file
Project17     : UVM SystemVerilog17 Cluster17 Level17 Verification17
Created17     :
Description17 :
Notes17       :  
----------------------------------------------------------------------*/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------


`ifndef SPI_CFG_SVH17
`define SPI_CFG_SVH17

class spi_config17 extends uvm_object;

  function new (string name = "");
    super.new(name);
  endfunction

  uvm_active_passive_enum  active_passive17 = UVM_ACTIVE;

  `uvm_object_utils_begin(spi_config17)
    `uvm_field_enum(uvm_active_passive_enum, active_passive17, UVM_ALL_ON)
   `uvm_object_utils_end

endclass

`endif

