/*-------------------------------------------------------------------------
File8 name   : spi_agent8.sv
Title8       : SPI8 SystemVerilog8 UVM UVC8
Project8     : UVM SystemVerilog8 Cluster8 Level8 Verification8
Created8     :
Description8 : 
Notes8       :  
---------------------------------------------------------------------------*/
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


`ifndef SPI_AGENT_SV8
`define SPI_AGENT_SV8

class spi_agent8 extends uvm_agent;

  uvm_active_passive_enum is_active = UVM_ACTIVE;
  int agent_id8;

  spi_driver8 driver;
  spi_sequencer8 sequencer;
  spi_monitor8 monitor8;

  // Provide8 implementations8 of virtual methods8 such8 as get_type_name and create
  `uvm_component_utils_begin(spi_agent8)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
    `uvm_field_int(agent_id8, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor8 = spi_monitor8::type_id::create("monitor8", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = spi_sequencer8::type_id::create("sequencer", this);
      driver = spi_driver8::type_id::create("driver", this);
      driver.monitor8 = monitor8;
    end
  endfunction : build_phase

  // connect
  function void connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

  // assign csr8 of the agent8's cheldren8
  function void assign_csr8(spi_csr_s8 csr_s8);
    monitor8.csr_s8 = csr_s8;
    if (is_active == UVM_ACTIVE) begin
      driver.csr_s8 = csr_s8;
    end
  endfunction : assign_csr8

endclass : spi_agent8

`endif // SPI_AGENT_SV8

