/*-------------------------------------------------------------------------
File27 name   : uart_rx_agent27.sv
Title27       : Rx27 Agent27 file
Project27     :
Created27     :
Description27 : build Monitor27, Sequencer,Driver27 and connect Sequencer and driver
Notes27       :  
----------------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------

  
`ifndef UART_RX_AGENT_SV27
`define UART_RX_AGENT_SV27

class uart_rx_agent27 extends uvm_agent;

  // Active27/Passive27 Agent27 configuration
  //uvm_active_passive_enum is_active = UVM_ACTIVE;
  
  // Pointer27 to the UART27 config
  uart_config27 cfg;

  uart_rx_monitor27 monitor27;
  uart_rx_driver27 driver;     
  uart_sequencer27 sequencer;

  // Provides27 implementation of methods27 such27 as get_type_name and create
  `uvm_component_utils_begin(uart_rx_agent27)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end 

  // Constructor27 - UVM required27 syntax27
  function new(string name = "", uvm_component parent); 
    super.new(name, parent);
  endfunction

  // Additional27 class methods27
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config27(uart_config27 cfg);
  
endclass : uart_rx_agent27

// UVM build_phase
function void uart_rx_agent27::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure27
  if (cfg == null) begin
    if (!uvm_config_db#(uart_config27)::get(this, "", "cfg", cfg))
    `uvm_warning("NOCONFIG27", "Config27 not set for Rx27 agent27, using default is_active field")
  end
  else is_active = cfg.is_rx_active27;

  monitor27 = uart_rx_monitor27::type_id::create("monitor27",this);
  if (is_active == UVM_ACTIVE) begin
    //If27 UVM_ACTIVE create instances27 of UART27 Driver27 and Sequencer
    sequencer = uart_sequencer27::type_id::create("sequencer",this);
    driver = uart_rx_driver27::type_id::create("driver",this);
  end
endfunction : build_phase

// UVM connect_phase
function void uart_rx_agent27::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (is_active == UVM_ACTIVE) begin
    // Binds27 the driver to the sequencer using TLM port connections27
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

// Assign27 the config to the agent27's children
function void uart_rx_agent27::update_config27( uart_config27 cfg);
  monitor27.cfg = cfg;
  if (is_active == UVM_ACTIVE) begin
    driver.cfg = cfg;
  end
endfunction : update_config27

`endif  //UART_RX_AGENT_SV27
