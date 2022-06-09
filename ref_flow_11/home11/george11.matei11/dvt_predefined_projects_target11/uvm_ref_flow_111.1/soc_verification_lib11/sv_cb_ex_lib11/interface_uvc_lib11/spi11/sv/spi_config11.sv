/*-------------------------------------------------------------------------
File11 name   : spi_config11.sv
Title11       : SPI11 environment11 configuration file
Project11     : UVM SystemVerilog11 Cluster11 Level11 Verification11
Created11     :
Description11 :
Notes11       :  
----------------------------------------------------------------------*/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------


`ifndef SPI_CFG_SVH11
`define SPI_CFG_SVH11

class spi_config11 extends uvm_object;

  function new (string name = "");
    super.new(name);
  endfunction

  uvm_active_passive_enum  active_passive11 = UVM_ACTIVE;

  `uvm_object_utils_begin(spi_config11)
    `uvm_field_enum(uvm_active_passive_enum, active_passive11, UVM_ALL_ON)
   `uvm_object_utils_end

endclass

`endif

