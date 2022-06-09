/*-------------------------------------------------------------------------
File28 name   : uart_tx_agent28.sv
Title28       : Tx28 Agent28 file
Project28     :
Created28     :
Description28 : build Monitor28, Sequencer,Driver28 and connect Sequencer and driver
Notes28       :  
----------------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------

  
`ifndef UART_TX_AGENT_SVH28
`define UART_TX_AGENT_SVH28

class uart_tx_agent28 extends uvm_agent;

  // Active28/Passive28 Agent28 configuration
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Configuration28
  uart_config28 cfg;
  
  uart_tx_monitor28 monitor28;
  uart_tx_driver28 driver;
  uart_sequencer28 sequencer;

  // Provides28 implementation of methods28 such28 as get_type_name and create
  `uvm_component_utils_begin(uart_tx_agent28)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end 

  // Constructor28 - UVM required28 syntax28
  function new(string name = "", uvm_component parent); 
    super.new(name, parent);
  endfunction

  // Additional28 class methods28
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config28(uart_config28 cfg);
  
endclass : uart_tx_agent28

// UVM build_phase
function void uart_tx_agent28::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure28
  if (cfg == null) begin
    if (!uvm_config_db#(uart_config28)::get(this, "", "cfg", cfg))
    `uvm_warning("NOCONFIG28", "Config28 not set for Tx28 agent28, using default is_active field")
  end
  else is_active = cfg.is_tx_active28;
  monitor28 = uart_tx_monitor28::type_id::create("monitor28",this);   //lab3_note128
  if (is_active == UVM_ACTIVE) begin
    //If28 UVM_ACTIVE create instances28 of UART28 Driver28 and Sequencer
    sequencer = uart_sequencer28::type_id::create("sequencer",this);
    driver = uart_tx_driver28::type_id::create("driver",this);
  end
endfunction : build_phase

// UVM connect() phase
function void uart_tx_agent28::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (is_active == UVM_ACTIVE) begin
    // Binds28 the driver to the sequencer using TLM port connections28
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

// Assign28 the config to the agent28's children
function void uart_tx_agent28::update_config28( uart_config28 cfg);
  monitor28.cfg = cfg;
  if (is_active == UVM_ACTIVE) begin
    driver.cfg = cfg;
    sequencer.cfg = cfg;
  end
endfunction : update_config28

`endif
