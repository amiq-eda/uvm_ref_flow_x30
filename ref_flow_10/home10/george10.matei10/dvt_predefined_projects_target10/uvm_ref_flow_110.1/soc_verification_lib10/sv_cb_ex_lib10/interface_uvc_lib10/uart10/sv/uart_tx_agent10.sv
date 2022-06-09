/*-------------------------------------------------------------------------
File10 name   : uart_tx_agent10.sv
Title10       : Tx10 Agent10 file
Project10     :
Created10     :
Description10 : build Monitor10, Sequencer,Driver10 and connect Sequencer and driver
Notes10       :  
----------------------------------------------------------------------*/
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

  
`ifndef UART_TX_AGENT_SVH10
`define UART_TX_AGENT_SVH10

class uart_tx_agent10 extends uvm_agent;

  // Active10/Passive10 Agent10 configuration
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Configuration10
  uart_config10 cfg;
  
  uart_tx_monitor10 monitor10;
  uart_tx_driver10 driver;
  uart_sequencer10 sequencer;

  // Provides10 implementation of methods10 such10 as get_type_name and create
  `uvm_component_utils_begin(uart_tx_agent10)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end 

  // Constructor10 - UVM required10 syntax10
  function new(string name = "", uvm_component parent); 
    super.new(name, parent);
  endfunction

  // Additional10 class methods10
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config10(uart_config10 cfg);
  
endclass : uart_tx_agent10

// UVM build_phase
function void uart_tx_agent10::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure10
  if (cfg == null) begin
    if (!uvm_config_db#(uart_config10)::get(this, "", "cfg", cfg))
    `uvm_warning("NOCONFIG10", "Config10 not set for Tx10 agent10, using default is_active field")
  end
  else is_active = cfg.is_tx_active10;
  monitor10 = uart_tx_monitor10::type_id::create("monitor10",this);   //lab3_note110
  if (is_active == UVM_ACTIVE) begin
    //If10 UVM_ACTIVE create instances10 of UART10 Driver10 and Sequencer
    sequencer = uart_sequencer10::type_id::create("sequencer",this);
    driver = uart_tx_driver10::type_id::create("driver",this);
  end
endfunction : build_phase

// UVM connect() phase
function void uart_tx_agent10::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (is_active == UVM_ACTIVE) begin
    // Binds10 the driver to the sequencer using TLM port connections10
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

// Assign10 the config to the agent10's children
function void uart_tx_agent10::update_config10( uart_config10 cfg);
  monitor10.cfg = cfg;
  if (is_active == UVM_ACTIVE) begin
    driver.cfg = cfg;
    sequencer.cfg = cfg;
  end
endfunction : update_config10

`endif
