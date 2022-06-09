/*-------------------------------------------------------------------------
File10 name   : spi_agent10.sv
Title10       : SPI10 SystemVerilog10 UVM UVC10
Project10     : UVM SystemVerilog10 Cluster10 Level10 Verification10
Created10     :
Description10 : 
Notes10       :  
---------------------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------


`ifndef SPI_AGENT_SV10
`define SPI_AGENT_SV10

class spi_agent10 extends uvm_agent;

  uvm_active_passive_enum is_active = UVM_ACTIVE;
  int agent_id10;

  spi_driver10 driver;
  spi_sequencer10 sequencer;
  spi_monitor10 monitor10;

  // Provide10 implementations10 of virtual methods10 such10 as get_type_name and create
  `uvm_component_utils_begin(spi_agent10)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
    `uvm_field_int(agent_id10, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor10 = spi_monitor10::type_id::create("monitor10", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = spi_sequencer10::type_id::create("sequencer", this);
      driver = spi_driver10::type_id::create("driver", this);
      driver.monitor10 = monitor10;
    end
  endfunction : build_phase

  // connect
  function void connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

  // assign csr10 of the agent10's cheldren10
  function void assign_csr10(spi_csr_s10 csr_s10);
    monitor10.csr_s10 = csr_s10;
    if (is_active == UVM_ACTIVE) begin
      driver.csr_s10 = csr_s10;
    end
  endfunction : assign_csr10

endclass : spi_agent10

`endif // SPI_AGENT_SV10

