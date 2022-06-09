/*-------------------------------------------------------------------------
File3 name   : spi_config3.sv
Title3       : SPI3 environment3 configuration file
Project3     : UVM SystemVerilog3 Cluster3 Level3 Verification3
Created3     :
Description3 :
Notes3       :  
----------------------------------------------------------------------*/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------


`ifndef SPI_CFG_SVH3
`define SPI_CFG_SVH3

class spi_config3 extends uvm_object;

  function new (string name = "");
    super.new(name);
  endfunction

  uvm_active_passive_enum  active_passive3 = UVM_ACTIVE;

  `uvm_object_utils_begin(spi_config3)
    `uvm_field_enum(uvm_active_passive_enum, active_passive3, UVM_ALL_ON)
   `uvm_object_utils_end

endclass

`endif

