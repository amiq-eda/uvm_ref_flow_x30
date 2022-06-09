/*-------------------------------------------------------------------------
File23 name   : uart_tx_agent23.sv
Title23       : Tx23 Agent23 file
Project23     :
Created23     :
Description23 : build Monitor23, Sequencer,Driver23 and connect Sequencer and driver
Notes23       :  
----------------------------------------------------------------------*/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------

  
`ifndef UART_TX_AGENT_SVH23
`define UART_TX_AGENT_SVH23

class uart_tx_agent23 extends uvm_agent;

  // Active23/Passive23 Agent23 configuration
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Configuration23
  uart_config23 cfg;
  
  uart_tx_monitor23 monitor23;
  uart_tx_driver23 driver;
  uart_sequencer23 sequencer;

  // Provides23 implementation of methods23 such23 as get_type_name and create
  `uvm_component_utils_begin(uart_tx_agent23)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end 

  // Constructor23 - UVM required23 syntax23
  function new(string name = "", uvm_component parent); 
    super.new(name, parent);
  endfunction

  // Additional23 class methods23
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config23(uart_config23 cfg);
  
endclass : uart_tx_agent23

// UVM build_phase
function void uart_tx_agent23::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure23
  if (cfg == null) begin
    if (!uvm_config_db#(uart_config23)::get(this, "", "cfg", cfg))
    `uvm_warning("NOCONFIG23", "Config23 not set for Tx23 agent23, using default is_active field")
  end
  else is_active = cfg.is_tx_active23;
  monitor23 = uart_tx_monitor23::type_id::create("monitor23",this);   //lab3_note123
  if (is_active == UVM_ACTIVE) begin
    //If23 UVM_ACTIVE create instances23 of UART23 Driver23 and Sequencer
    sequencer = uart_sequencer23::type_id::create("sequencer",this);
    driver = uart_tx_driver23::type_id::create("driver",this);
  end
endfunction : build_phase

// UVM connect() phase
function void uart_tx_agent23::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (is_active == UVM_ACTIVE) begin
    // Binds23 the driver to the sequencer using TLM port connections23
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

// Assign23 the config to the agent23's children
function void uart_tx_agent23::update_config23( uart_config23 cfg);
  monitor23.cfg = cfg;
  if (is_active == UVM_ACTIVE) begin
    driver.cfg = cfg;
    sequencer.cfg = cfg;
  end
endfunction : update_config23

`endif
