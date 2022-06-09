/*-------------------------------------------------------------------------
File6 name   : spi_config6.sv
Title6       : SPI6 environment6 configuration file
Project6     : UVM SystemVerilog6 Cluster6 Level6 Verification6
Created6     :
Description6 :
Notes6       :  
----------------------------------------------------------------------*/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------


`ifndef SPI_CFG_SVH6
`define SPI_CFG_SVH6

class spi_config6 extends uvm_object;

  function new (string name = "");
    super.new(name);
  endfunction

  uvm_active_passive_enum  active_passive6 = UVM_ACTIVE;

  `uvm_object_utils_begin(spi_config6)
    `uvm_field_enum(uvm_active_passive_enum, active_passive6, UVM_ALL_ON)
   `uvm_object_utils_end

endclass

`endif

