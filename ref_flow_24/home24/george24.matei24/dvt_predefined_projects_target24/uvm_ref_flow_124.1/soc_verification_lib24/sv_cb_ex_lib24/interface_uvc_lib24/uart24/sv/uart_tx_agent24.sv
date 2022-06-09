/*-------------------------------------------------------------------------
File24 name   : uart_tx_agent24.sv
Title24       : Tx24 Agent24 file
Project24     :
Created24     :
Description24 : build Monitor24, Sequencer,Driver24 and connect Sequencer and driver
Notes24       :  
----------------------------------------------------------------------*/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------

  
`ifndef UART_TX_AGENT_SVH24
`define UART_TX_AGENT_SVH24

class uart_tx_agent24 extends uvm_agent;

  // Active24/Passive24 Agent24 configuration
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Configuration24
  uart_config24 cfg;
  
  uart_tx_monitor24 monitor24;
  uart_tx_driver24 driver;
  uart_sequencer24 sequencer;

  // Provides24 implementation of methods24 such24 as get_type_name and create
  `uvm_component_utils_begin(uart_tx_agent24)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end 

  // Constructor24 - UVM required24 syntax24
  function new(string name = "", uvm_component parent); 
    super.new(name, parent);
  endfunction

  // Additional24 class methods24
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config24(uart_config24 cfg);
  
endclass : uart_tx_agent24

// UVM build_phase
function void uart_tx_agent24::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure24
  if (cfg == null) begin
    if (!uvm_config_db#(uart_config24)::get(this, "", "cfg", cfg))
    `uvm_warning("NOCONFIG24", "Config24 not set for Tx24 agent24, using default is_active field")
  end
  else is_active = cfg.is_tx_active24;
  monitor24 = uart_tx_monitor24::type_id::create("monitor24",this);   //lab3_note124
  if (is_active == UVM_ACTIVE) begin
    //If24 UVM_ACTIVE create instances24 of UART24 Driver24 and Sequencer
    sequencer = uart_sequencer24::type_id::create("sequencer",this);
    driver = uart_tx_driver24::type_id::create("driver",this);
  end
endfunction : build_phase

// UVM connect() phase
function void uart_tx_agent24::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (is_active == UVM_ACTIVE) begin
    // Binds24 the driver to the sequencer using TLM port connections24
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

// Assign24 the config to the agent24's children
function void uart_tx_agent24::update_config24( uart_config24 cfg);
  monitor24.cfg = cfg;
  if (is_active == UVM_ACTIVE) begin
    driver.cfg = cfg;
    sequencer.cfg = cfg;
  end
endfunction : update_config24

`endif
