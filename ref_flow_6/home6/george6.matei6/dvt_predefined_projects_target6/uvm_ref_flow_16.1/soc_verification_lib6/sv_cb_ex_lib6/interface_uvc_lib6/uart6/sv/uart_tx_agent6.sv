/*-------------------------------------------------------------------------
File6 name   : uart_tx_agent6.sv
Title6       : Tx6 Agent6 file
Project6     :
Created6     :
Description6 : build Monitor6, Sequencer,Driver6 and connect Sequencer and driver
Notes6       :  
----------------------------------------------------------------------*/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------

  
`ifndef UART_TX_AGENT_SVH6
`define UART_TX_AGENT_SVH6

class uart_tx_agent6 extends uvm_agent;

  // Active6/Passive6 Agent6 configuration
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Configuration6
  uart_config6 cfg;
  
  uart_tx_monitor6 monitor6;
  uart_tx_driver6 driver;
  uart_sequencer6 sequencer;

  // Provides6 implementation of methods6 such6 as get_type_name and create
  `uvm_component_utils_begin(uart_tx_agent6)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end 

  // Constructor6 - UVM required6 syntax6
  function new(string name = "", uvm_component parent); 
    super.new(name, parent);
  endfunction

  // Additional6 class methods6
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config6(uart_config6 cfg);
  
endclass : uart_tx_agent6

// UVM build_phase
function void uart_tx_agent6::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure6
  if (cfg == null) begin
    if (!uvm_config_db#(uart_config6)::get(this, "", "cfg", cfg))
    `uvm_warning("NOCONFIG6", "Config6 not set for Tx6 agent6, using default is_active field")
  end
  else is_active = cfg.is_tx_active6;
  monitor6 = uart_tx_monitor6::type_id::create("monitor6",this);   //lab3_note16
  if (is_active == UVM_ACTIVE) begin
    //If6 UVM_ACTIVE create instances6 of UART6 Driver6 and Sequencer
    sequencer = uart_sequencer6::type_id::create("sequencer",this);
    driver = uart_tx_driver6::type_id::create("driver",this);
  end
endfunction : build_phase

// UVM connect() phase
function void uart_tx_agent6::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (is_active == UVM_ACTIVE) begin
    // Binds6 the driver to the sequencer using TLM port connections6
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

// Assign6 the config to the agent6's children
function void uart_tx_agent6::update_config6( uart_config6 cfg);
  monitor6.cfg = cfg;
  if (is_active == UVM_ACTIVE) begin
    driver.cfg = cfg;
    sequencer.cfg = cfg;
  end
endfunction : update_config6

`endif
