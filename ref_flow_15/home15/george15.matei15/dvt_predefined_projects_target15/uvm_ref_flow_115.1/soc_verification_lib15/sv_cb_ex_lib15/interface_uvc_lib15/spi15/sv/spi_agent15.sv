/*-------------------------------------------------------------------------
File15 name   : spi_agent15.sv
Title15       : SPI15 SystemVerilog15 UVM UVC15
Project15     : UVM SystemVerilog15 Cluster15 Level15 Verification15
Created15     :
Description15 : 
Notes15       :  
---------------------------------------------------------------------------*/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------


`ifndef SPI_AGENT_SV15
`define SPI_AGENT_SV15

class spi_agent15 extends uvm_agent;

  uvm_active_passive_enum is_active = UVM_ACTIVE;
  int agent_id15;

  spi_driver15 driver;
  spi_sequencer15 sequencer;
  spi_monitor15 monitor15;

  // Provide15 implementations15 of virtual methods15 such15 as get_type_name and create
  `uvm_component_utils_begin(spi_agent15)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
    `uvm_field_int(agent_id15, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor15 = spi_monitor15::type_id::create("monitor15", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = spi_sequencer15::type_id::create("sequencer", this);
      driver = spi_driver15::type_id::create("driver", this);
      driver.monitor15 = monitor15;
    end
  endfunction : build_phase

  // connect
  function void connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

  // assign csr15 of the agent15's cheldren15
  function void assign_csr15(spi_csr_s15 csr_s15);
    monitor15.csr_s15 = csr_s15;
    if (is_active == UVM_ACTIVE) begin
      driver.csr_s15 = csr_s15;
    end
  endfunction : assign_csr15

endclass : spi_agent15

`endif // SPI_AGENT_SV15

