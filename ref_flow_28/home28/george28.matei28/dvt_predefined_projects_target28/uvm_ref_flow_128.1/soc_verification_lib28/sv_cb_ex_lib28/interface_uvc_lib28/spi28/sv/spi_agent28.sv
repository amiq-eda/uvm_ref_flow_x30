/*-------------------------------------------------------------------------
File28 name   : spi_agent28.sv
Title28       : SPI28 SystemVerilog28 UVM UVC28
Project28     : UVM SystemVerilog28 Cluster28 Level28 Verification28
Created28     :
Description28 : 
Notes28       :  
---------------------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------


`ifndef SPI_AGENT_SV28
`define SPI_AGENT_SV28

class spi_agent28 extends uvm_agent;

  uvm_active_passive_enum is_active = UVM_ACTIVE;
  int agent_id28;

  spi_driver28 driver;
  spi_sequencer28 sequencer;
  spi_monitor28 monitor28;

  // Provide28 implementations28 of virtual methods28 such28 as get_type_name and create
  `uvm_component_utils_begin(spi_agent28)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
    `uvm_field_int(agent_id28, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor28 = spi_monitor28::type_id::create("monitor28", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = spi_sequencer28::type_id::create("sequencer", this);
      driver = spi_driver28::type_id::create("driver", this);
      driver.monitor28 = monitor28;
    end
  endfunction : build_phase

  // connect
  function void connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

  // assign csr28 of the agent28's cheldren28
  function void assign_csr28(spi_csr_s28 csr_s28);
    monitor28.csr_s28 = csr_s28;
    if (is_active == UVM_ACTIVE) begin
      driver.csr_s28 = csr_s28;
    end
  endfunction : assign_csr28

endclass : spi_agent28

`endif // SPI_AGENT_SV28

