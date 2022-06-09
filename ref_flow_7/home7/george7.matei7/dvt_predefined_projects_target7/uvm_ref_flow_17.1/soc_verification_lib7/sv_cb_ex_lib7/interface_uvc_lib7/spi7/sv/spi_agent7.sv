/*-------------------------------------------------------------------------
File7 name   : spi_agent7.sv
Title7       : SPI7 SystemVerilog7 UVM UVC7
Project7     : UVM SystemVerilog7 Cluster7 Level7 Verification7
Created7     :
Description7 : 
Notes7       :  
---------------------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------


`ifndef SPI_AGENT_SV7
`define SPI_AGENT_SV7

class spi_agent7 extends uvm_agent;

  uvm_active_passive_enum is_active = UVM_ACTIVE;
  int agent_id7;

  spi_driver7 driver;
  spi_sequencer7 sequencer;
  spi_monitor7 monitor7;

  // Provide7 implementations7 of virtual methods7 such7 as get_type_name and create
  `uvm_component_utils_begin(spi_agent7)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
    `uvm_field_int(agent_id7, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor7 = spi_monitor7::type_id::create("monitor7", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = spi_sequencer7::type_id::create("sequencer", this);
      driver = spi_driver7::type_id::create("driver", this);
      driver.monitor7 = monitor7;
    end
  endfunction : build_phase

  // connect
  function void connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

  // assign csr7 of the agent7's cheldren7
  function void assign_csr7(spi_csr_s7 csr_s7);
    monitor7.csr_s7 = csr_s7;
    if (is_active == UVM_ACTIVE) begin
      driver.csr_s7 = csr_s7;
    end
  endfunction : assign_csr7

endclass : spi_agent7

`endif // SPI_AGENT_SV7

