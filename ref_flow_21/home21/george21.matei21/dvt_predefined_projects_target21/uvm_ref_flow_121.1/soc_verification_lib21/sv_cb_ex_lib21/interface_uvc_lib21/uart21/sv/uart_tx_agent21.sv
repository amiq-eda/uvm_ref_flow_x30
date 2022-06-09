/*-------------------------------------------------------------------------
File21 name   : uart_tx_agent21.sv
Title21       : Tx21 Agent21 file
Project21     :
Created21     :
Description21 : build Monitor21, Sequencer,Driver21 and connect Sequencer and driver
Notes21       :  
----------------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------

  
`ifndef UART_TX_AGENT_SVH21
`define UART_TX_AGENT_SVH21

class uart_tx_agent21 extends uvm_agent;

  // Active21/Passive21 Agent21 configuration
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Configuration21
  uart_config21 cfg;
  
  uart_tx_monitor21 monitor21;
  uart_tx_driver21 driver;
  uart_sequencer21 sequencer;

  // Provides21 implementation of methods21 such21 as get_type_name and create
  `uvm_component_utils_begin(uart_tx_agent21)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end 

  // Constructor21 - UVM required21 syntax21
  function new(string name = "", uvm_component parent); 
    super.new(name, parent);
  endfunction

  // Additional21 class methods21
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config21(uart_config21 cfg);
  
endclass : uart_tx_agent21

// UVM build_phase
function void uart_tx_agent21::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure21
  if (cfg == null) begin
    if (!uvm_config_db#(uart_config21)::get(this, "", "cfg", cfg))
    `uvm_warning("NOCONFIG21", "Config21 not set for Tx21 agent21, using default is_active field")
  end
  else is_active = cfg.is_tx_active21;
  monitor21 = uart_tx_monitor21::type_id::create("monitor21",this);   //lab3_note121
  if (is_active == UVM_ACTIVE) begin
    //If21 UVM_ACTIVE create instances21 of UART21 Driver21 and Sequencer
    sequencer = uart_sequencer21::type_id::create("sequencer",this);
    driver = uart_tx_driver21::type_id::create("driver",this);
  end
endfunction : build_phase

// UVM connect() phase
function void uart_tx_agent21::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (is_active == UVM_ACTIVE) begin
    // Binds21 the driver to the sequencer using TLM port connections21
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

// Assign21 the config to the agent21's children
function void uart_tx_agent21::update_config21( uart_config21 cfg);
  monitor21.cfg = cfg;
  if (is_active == UVM_ACTIVE) begin
    driver.cfg = cfg;
    sequencer.cfg = cfg;
  end
endfunction : update_config21

`endif
