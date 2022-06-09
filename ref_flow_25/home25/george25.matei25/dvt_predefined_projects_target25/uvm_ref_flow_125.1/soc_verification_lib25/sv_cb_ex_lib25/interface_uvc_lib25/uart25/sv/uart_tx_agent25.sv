/*-------------------------------------------------------------------------
File25 name   : uart_tx_agent25.sv
Title25       : Tx25 Agent25 file
Project25     :
Created25     :
Description25 : build Monitor25, Sequencer,Driver25 and connect Sequencer and driver
Notes25       :  
----------------------------------------------------------------------*/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------

  
`ifndef UART_TX_AGENT_SVH25
`define UART_TX_AGENT_SVH25

class uart_tx_agent25 extends uvm_agent;

  // Active25/Passive25 Agent25 configuration
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Configuration25
  uart_config25 cfg;
  
  uart_tx_monitor25 monitor25;
  uart_tx_driver25 driver;
  uart_sequencer25 sequencer;

  // Provides25 implementation of methods25 such25 as get_type_name and create
  `uvm_component_utils_begin(uart_tx_agent25)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end 

  // Constructor25 - UVM required25 syntax25
  function new(string name = "", uvm_component parent); 
    super.new(name, parent);
  endfunction

  // Additional25 class methods25
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config25(uart_config25 cfg);
  
endclass : uart_tx_agent25

// UVM build_phase
function void uart_tx_agent25::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure25
  if (cfg == null) begin
    if (!uvm_config_db#(uart_config25)::get(this, "", "cfg", cfg))
    `uvm_warning("NOCONFIG25", "Config25 not set for Tx25 agent25, using default is_active field")
  end
  else is_active = cfg.is_tx_active25;
  monitor25 = uart_tx_monitor25::type_id::create("monitor25",this);   //lab3_note125
  if (is_active == UVM_ACTIVE) begin
    //If25 UVM_ACTIVE create instances25 of UART25 Driver25 and Sequencer
    sequencer = uart_sequencer25::type_id::create("sequencer",this);
    driver = uart_tx_driver25::type_id::create("driver",this);
  end
endfunction : build_phase

// UVM connect() phase
function void uart_tx_agent25::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (is_active == UVM_ACTIVE) begin
    // Binds25 the driver to the sequencer using TLM port connections25
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

// Assign25 the config to the agent25's children
function void uart_tx_agent25::update_config25( uart_config25 cfg);
  monitor25.cfg = cfg;
  if (is_active == UVM_ACTIVE) begin
    driver.cfg = cfg;
    sequencer.cfg = cfg;
  end
endfunction : update_config25

`endif
