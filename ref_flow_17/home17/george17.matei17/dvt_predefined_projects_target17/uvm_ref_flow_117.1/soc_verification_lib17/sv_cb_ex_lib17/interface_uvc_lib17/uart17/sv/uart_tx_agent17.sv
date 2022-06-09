/*-------------------------------------------------------------------------
File17 name   : uart_tx_agent17.sv
Title17       : Tx17 Agent17 file
Project17     :
Created17     :
Description17 : build Monitor17, Sequencer,Driver17 and connect Sequencer and driver
Notes17       :  
----------------------------------------------------------------------*/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------

  
`ifndef UART_TX_AGENT_SVH17
`define UART_TX_AGENT_SVH17

class uart_tx_agent17 extends uvm_agent;

  // Active17/Passive17 Agent17 configuration
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Configuration17
  uart_config17 cfg;
  
  uart_tx_monitor17 monitor17;
  uart_tx_driver17 driver;
  uart_sequencer17 sequencer;

  // Provides17 implementation of methods17 such17 as get_type_name and create
  `uvm_component_utils_begin(uart_tx_agent17)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end 

  // Constructor17 - UVM required17 syntax17
  function new(string name = "", uvm_component parent); 
    super.new(name, parent);
  endfunction

  // Additional17 class methods17
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config17(uart_config17 cfg);
  
endclass : uart_tx_agent17

// UVM build_phase
function void uart_tx_agent17::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure17
  if (cfg == null) begin
    if (!uvm_config_db#(uart_config17)::get(this, "", "cfg", cfg))
    `uvm_warning("NOCONFIG17", "Config17 not set for Tx17 agent17, using default is_active field")
  end
  else is_active = cfg.is_tx_active17;
  monitor17 = uart_tx_monitor17::type_id::create("monitor17",this);   //lab3_note117
  if (is_active == UVM_ACTIVE) begin
    //If17 UVM_ACTIVE create instances17 of UART17 Driver17 and Sequencer
    sequencer = uart_sequencer17::type_id::create("sequencer",this);
    driver = uart_tx_driver17::type_id::create("driver",this);
  end
endfunction : build_phase

// UVM connect() phase
function void uart_tx_agent17::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (is_active == UVM_ACTIVE) begin
    // Binds17 the driver to the sequencer using TLM port connections17
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

// Assign17 the config to the agent17's children
function void uart_tx_agent17::update_config17( uart_config17 cfg);
  monitor17.cfg = cfg;
  if (is_active == UVM_ACTIVE) begin
    driver.cfg = cfg;
    sequencer.cfg = cfg;
  end
endfunction : update_config17

`endif
