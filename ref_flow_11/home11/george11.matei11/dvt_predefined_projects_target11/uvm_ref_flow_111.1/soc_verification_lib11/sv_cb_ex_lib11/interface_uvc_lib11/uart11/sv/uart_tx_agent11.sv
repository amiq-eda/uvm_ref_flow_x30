/*-------------------------------------------------------------------------
File11 name   : uart_tx_agent11.sv
Title11       : Tx11 Agent11 file
Project11     :
Created11     :
Description11 : build Monitor11, Sequencer,Driver11 and connect Sequencer and driver
Notes11       :  
----------------------------------------------------------------------*/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------

  
`ifndef UART_TX_AGENT_SVH11
`define UART_TX_AGENT_SVH11

class uart_tx_agent11 extends uvm_agent;

  // Active11/Passive11 Agent11 configuration
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Configuration11
  uart_config11 cfg;
  
  uart_tx_monitor11 monitor11;
  uart_tx_driver11 driver;
  uart_sequencer11 sequencer;

  // Provides11 implementation of methods11 such11 as get_type_name and create
  `uvm_component_utils_begin(uart_tx_agent11)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end 

  // Constructor11 - UVM required11 syntax11
  function new(string name = "", uvm_component parent); 
    super.new(name, parent);
  endfunction

  // Additional11 class methods11
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config11(uart_config11 cfg);
  
endclass : uart_tx_agent11

// UVM build_phase
function void uart_tx_agent11::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure11
  if (cfg == null) begin
    if (!uvm_config_db#(uart_config11)::get(this, "", "cfg", cfg))
    `uvm_warning("NOCONFIG11", "Config11 not set for Tx11 agent11, using default is_active field")
  end
  else is_active = cfg.is_tx_active11;
  monitor11 = uart_tx_monitor11::type_id::create("monitor11",this);   //lab3_note111
  if (is_active == UVM_ACTIVE) begin
    //If11 UVM_ACTIVE create instances11 of UART11 Driver11 and Sequencer
    sequencer = uart_sequencer11::type_id::create("sequencer",this);
    driver = uart_tx_driver11::type_id::create("driver",this);
  end
endfunction : build_phase

// UVM connect() phase
function void uart_tx_agent11::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (is_active == UVM_ACTIVE) begin
    // Binds11 the driver to the sequencer using TLM port connections11
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

// Assign11 the config to the agent11's children
function void uart_tx_agent11::update_config11( uart_config11 cfg);
  monitor11.cfg = cfg;
  if (is_active == UVM_ACTIVE) begin
    driver.cfg = cfg;
    sequencer.cfg = cfg;
  end
endfunction : update_config11

`endif
