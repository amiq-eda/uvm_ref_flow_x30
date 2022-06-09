/*-------------------------------------------------------------------------
File26 name   : uart_rx_agent26.sv
Title26       : Rx26 Agent26 file
Project26     :
Created26     :
Description26 : build Monitor26, Sequencer,Driver26 and connect Sequencer and driver
Notes26       :  
----------------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------

  
`ifndef UART_RX_AGENT_SV26
`define UART_RX_AGENT_SV26

class uart_rx_agent26 extends uvm_agent;

  // Active26/Passive26 Agent26 configuration
  //uvm_active_passive_enum is_active = UVM_ACTIVE;
  
  // Pointer26 to the UART26 config
  uart_config26 cfg;

  uart_rx_monitor26 monitor26;
  uart_rx_driver26 driver;     
  uart_sequencer26 sequencer;

  // Provides26 implementation of methods26 such26 as get_type_name and create
  `uvm_component_utils_begin(uart_rx_agent26)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end 

  // Constructor26 - UVM required26 syntax26
  function new(string name = "", uvm_component parent); 
    super.new(name, parent);
  endfunction

  // Additional26 class methods26
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config26(uart_config26 cfg);
  
endclass : uart_rx_agent26

// UVM build_phase
function void uart_rx_agent26::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure26
  if (cfg == null) begin
    if (!uvm_config_db#(uart_config26)::get(this, "", "cfg", cfg))
    `uvm_warning("NOCONFIG26", "Config26 not set for Rx26 agent26, using default is_active field")
  end
  else is_active = cfg.is_rx_active26;

  monitor26 = uart_rx_monitor26::type_id::create("monitor26",this);
  if (is_active == UVM_ACTIVE) begin
    //If26 UVM_ACTIVE create instances26 of UART26 Driver26 and Sequencer
    sequencer = uart_sequencer26::type_id::create("sequencer",this);
    driver = uart_rx_driver26::type_id::create("driver",this);
  end
endfunction : build_phase

// UVM connect_phase
function void uart_rx_agent26::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (is_active == UVM_ACTIVE) begin
    // Binds26 the driver to the sequencer using TLM port connections26
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

// Assign26 the config to the agent26's children
function void uart_rx_agent26::update_config26( uart_config26 cfg);
  monitor26.cfg = cfg;
  if (is_active == UVM_ACTIVE) begin
    driver.cfg = cfg;
  end
endfunction : update_config26

`endif  //UART_RX_AGENT_SV26
