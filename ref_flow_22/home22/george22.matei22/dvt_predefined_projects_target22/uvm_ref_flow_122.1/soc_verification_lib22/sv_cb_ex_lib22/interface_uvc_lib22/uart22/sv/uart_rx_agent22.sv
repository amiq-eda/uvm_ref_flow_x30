/*-------------------------------------------------------------------------
File22 name   : uart_rx_agent22.sv
Title22       : Rx22 Agent22 file
Project22     :
Created22     :
Description22 : build Monitor22, Sequencer,Driver22 and connect Sequencer and driver
Notes22       :  
----------------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------

  
`ifndef UART_RX_AGENT_SV22
`define UART_RX_AGENT_SV22

class uart_rx_agent22 extends uvm_agent;

  // Active22/Passive22 Agent22 configuration
  //uvm_active_passive_enum is_active = UVM_ACTIVE;
  
  // Pointer22 to the UART22 config
  uart_config22 cfg;

  uart_rx_monitor22 monitor22;
  uart_rx_driver22 driver;     
  uart_sequencer22 sequencer;

  // Provides22 implementation of methods22 such22 as get_type_name and create
  `uvm_component_utils_begin(uart_rx_agent22)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end 

  // Constructor22 - UVM required22 syntax22
  function new(string name = "", uvm_component parent); 
    super.new(name, parent);
  endfunction

  // Additional22 class methods22
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config22(uart_config22 cfg);
  
endclass : uart_rx_agent22

// UVM build_phase
function void uart_rx_agent22::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure22
  if (cfg == null) begin
    if (!uvm_config_db#(uart_config22)::get(this, "", "cfg", cfg))
    `uvm_warning("NOCONFIG22", "Config22 not set for Rx22 agent22, using default is_active field")
  end
  else is_active = cfg.is_rx_active22;

  monitor22 = uart_rx_monitor22::type_id::create("monitor22",this);
  if (is_active == UVM_ACTIVE) begin
    //If22 UVM_ACTIVE create instances22 of UART22 Driver22 and Sequencer
    sequencer = uart_sequencer22::type_id::create("sequencer",this);
    driver = uart_rx_driver22::type_id::create("driver",this);
  end
endfunction : build_phase

// UVM connect_phase
function void uart_rx_agent22::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (is_active == UVM_ACTIVE) begin
    // Binds22 the driver to the sequencer using TLM port connections22
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

// Assign22 the config to the agent22's children
function void uart_rx_agent22::update_config22( uart_config22 cfg);
  monitor22.cfg = cfg;
  if (is_active == UVM_ACTIVE) begin
    driver.cfg = cfg;
  end
endfunction : update_config22

`endif  //UART_RX_AGENT_SV22
