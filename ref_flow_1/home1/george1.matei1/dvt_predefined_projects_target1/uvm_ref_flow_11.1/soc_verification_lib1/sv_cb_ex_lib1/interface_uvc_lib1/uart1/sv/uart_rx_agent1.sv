/*-------------------------------------------------------------------------
File1 name   : uart_rx_agent1.sv
Title1       : Rx1 Agent1 file
Project1     :
Created1     :
Description1 : build Monitor1, Sequencer,Driver1 and connect Sequencer and driver
Notes1       :  
----------------------------------------------------------------------*/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------

  
`ifndef UART_RX_AGENT_SV1
`define UART_RX_AGENT_SV1

class uart_rx_agent1 extends uvm_agent;

  // Active1/Passive1 Agent1 configuration
  //uvm_active_passive_enum is_active = UVM_ACTIVE;
  
  // Pointer1 to the UART1 config
  uart_config1 cfg;

  uart_rx_monitor1 monitor1;
  uart_rx_driver1 driver;     
  uart_sequencer1 sequencer;

  // Provides1 implementation of methods1 such1 as get_type_name and create
  `uvm_component_utils_begin(uart_rx_agent1)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end 

  // Constructor1 - UVM required1 syntax1
  function new(string name = "", uvm_component parent); 
    super.new(name, parent);
  endfunction

  // Additional1 class methods1
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config1(uart_config1 cfg);
  
endclass : uart_rx_agent1

// UVM build_phase
function void uart_rx_agent1::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure1
  if (cfg == null) begin
    if (!uvm_config_db#(uart_config1)::get(this, "", "cfg", cfg))
    `uvm_warning("NOCONFIG1", "Config1 not set for Rx1 agent1, using default is_active field")
  end
  else is_active = cfg.is_rx_active1;

  monitor1 = uart_rx_monitor1::type_id::create("monitor1",this);
  if (is_active == UVM_ACTIVE) begin
    //If1 UVM_ACTIVE create instances1 of UART1 Driver1 and Sequencer
    sequencer = uart_sequencer1::type_id::create("sequencer",this);
    driver = uart_rx_driver1::type_id::create("driver",this);
  end
endfunction : build_phase

// UVM connect_phase
function void uart_rx_agent1::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (is_active == UVM_ACTIVE) begin
    // Binds1 the driver to the sequencer using TLM port connections1
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

// Assign1 the config to the agent1's children
function void uart_rx_agent1::update_config1( uart_config1 cfg);
  monitor1.cfg = cfg;
  if (is_active == UVM_ACTIVE) begin
    driver.cfg = cfg;
  end
endfunction : update_config1

`endif  //UART_RX_AGENT_SV1
