/*-------------------------------------------------------------------------
File19 name   : spi_config19.sv
Title19       : SPI19 environment19 configuration file
Project19     : UVM SystemVerilog19 Cluster19 Level19 Verification19
Created19     :
Description19 :
Notes19       :  
----------------------------------------------------------------------*/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------


`ifndef SPI_CFG_SVH19
`define SPI_CFG_SVH19

class spi_config19 extends uvm_object;

  function new (string name = "");
    super.new(name);
  endfunction

  uvm_active_passive_enum  active_passive19 = UVM_ACTIVE;

  `uvm_object_utils_begin(spi_config19)
    `uvm_field_enum(uvm_active_passive_enum, active_passive19, UVM_ALL_ON)
   `uvm_object_utils_end

endclass

`endif

