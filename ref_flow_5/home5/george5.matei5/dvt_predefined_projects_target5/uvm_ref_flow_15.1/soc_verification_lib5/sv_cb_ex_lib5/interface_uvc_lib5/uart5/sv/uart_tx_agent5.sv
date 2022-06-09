/*-------------------------------------------------------------------------
File5 name   : uart_tx_agent5.sv
Title5       : Tx5 Agent5 file
Project5     :
Created5     :
Description5 : build Monitor5, Sequencer,Driver5 and connect Sequencer and driver
Notes5       :  
----------------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------

  
`ifndef UART_TX_AGENT_SVH5
`define UART_TX_AGENT_SVH5

class uart_tx_agent5 extends uvm_agent;

  // Active5/Passive5 Agent5 configuration
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Configuration5
  uart_config5 cfg;
  
  uart_tx_monitor5 monitor5;
  uart_tx_driver5 driver;
  uart_sequencer5 sequencer;

  // Provides5 implementation of methods5 such5 as get_type_name and create
  `uvm_component_utils_begin(uart_tx_agent5)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end 

  // Constructor5 - UVM required5 syntax5
  function new(string name = "", uvm_component parent); 
    super.new(name, parent);
  endfunction

  // Additional5 class methods5
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config5(uart_config5 cfg);
  
endclass : uart_tx_agent5

// UVM build_phase
function void uart_tx_agent5::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure5
  if (cfg == null) begin
    if (!uvm_config_db#(uart_config5)::get(this, "", "cfg", cfg))
    `uvm_warning("NOCONFIG5", "Config5 not set for Tx5 agent5, using default is_active field")
  end
  else is_active = cfg.is_tx_active5;
  monitor5 = uart_tx_monitor5::type_id::create("monitor5",this);   //lab3_note15
  if (is_active == UVM_ACTIVE) begin
    //If5 UVM_ACTIVE create instances5 of UART5 Driver5 and Sequencer
    sequencer = uart_sequencer5::type_id::create("sequencer",this);
    driver = uart_tx_driver5::type_id::create("driver",this);
  end
endfunction : build_phase

// UVM connect() phase
function void uart_tx_agent5::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (is_active == UVM_ACTIVE) begin
    // Binds5 the driver to the sequencer using TLM port connections5
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

// Assign5 the config to the agent5's children
function void uart_tx_agent5::update_config5( uart_config5 cfg);
  monitor5.cfg = cfg;
  if (is_active == UVM_ACTIVE) begin
    driver.cfg = cfg;
    sequencer.cfg = cfg;
  end
endfunction : update_config5

`endif
