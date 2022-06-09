/*-------------------------------------------------------------------------
File8 name   : uart_rx_agent8.sv
Title8       : Rx8 Agent8 file
Project8     :
Created8     :
Description8 : build Monitor8, Sequencer,Driver8 and connect Sequencer and driver
Notes8       :  
----------------------------------------------------------------------*/
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

  
`ifndef UART_RX_AGENT_SV8
`define UART_RX_AGENT_SV8

class uart_rx_agent8 extends uvm_agent;

  // Active8/Passive8 Agent8 configuration
  //uvm_active_passive_enum is_active = UVM_ACTIVE;
  
  // Pointer8 to the UART8 config
  uart_config8 cfg;

  uart_rx_monitor8 monitor8;
  uart_rx_driver8 driver;     
  uart_sequencer8 sequencer;

  // Provides8 implementation of methods8 such8 as get_type_name and create
  `uvm_component_utils_begin(uart_rx_agent8)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end 

  // Constructor8 - UVM required8 syntax8
  function new(string name = "", uvm_component parent); 
    super.new(name, parent);
  endfunction

  // Additional8 class methods8
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config8(uart_config8 cfg);
  
endclass : uart_rx_agent8

// UVM build_phase
function void uart_rx_agent8::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure8
  if (cfg == null) begin
    if (!uvm_config_db#(uart_config8)::get(this, "", "cfg", cfg))
    `uvm_warning("NOCONFIG8", "Config8 not set for Rx8 agent8, using default is_active field")
  end
  else is_active = cfg.is_rx_active8;

  monitor8 = uart_rx_monitor8::type_id::create("monitor8",this);
  if (is_active == UVM_ACTIVE) begin
    //If8 UVM_ACTIVE create instances8 of UART8 Driver8 and Sequencer
    sequencer = uart_sequencer8::type_id::create("sequencer",this);
    driver = uart_rx_driver8::type_id::create("driver",this);
  end
endfunction : build_phase

// UVM connect_phase
function void uart_rx_agent8::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (is_active == UVM_ACTIVE) begin
    // Binds8 the driver to the sequencer using TLM port connections8
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

// Assign8 the config to the agent8's children
function void uart_rx_agent8::update_config8( uart_config8 cfg);
  monitor8.cfg = cfg;
  if (is_active == UVM_ACTIVE) begin
    driver.cfg = cfg;
  end
endfunction : update_config8

`endif  //UART_RX_AGENT_SV8
