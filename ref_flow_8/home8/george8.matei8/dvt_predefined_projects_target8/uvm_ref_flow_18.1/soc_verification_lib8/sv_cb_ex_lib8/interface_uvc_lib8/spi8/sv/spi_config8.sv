/*-------------------------------------------------------------------------
File8 name   : spi_config8.sv
Title8       : SPI8 environment8 configuration file
Project8     : UVM SystemVerilog8 Cluster8 Level8 Verification8
Created8     :
Description8 :
Notes8       :  
----------------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------


`ifndef SPI_CFG_SVH8
`define SPI_CFG_SVH8

class spi_config8 extends uvm_object;

  function new (string name = "");
    super.new(name);
  endfunction

  uvm_active_passive_enum  active_passive8 = UVM_ACTIVE;

  `uvm_object_utils_begin(spi_config8)
    `uvm_field_enum(uvm_active_passive_enum, active_passive8, UVM_ALL_ON)
   `uvm_object_utils_end

endclass

`endif

