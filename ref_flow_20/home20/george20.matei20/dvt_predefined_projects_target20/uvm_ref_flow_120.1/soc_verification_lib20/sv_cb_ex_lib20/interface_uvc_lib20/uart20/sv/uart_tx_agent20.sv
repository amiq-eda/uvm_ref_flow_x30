/*-------------------------------------------------------------------------
File20 name   : uart_tx_agent20.sv
Title20       : Tx20 Agent20 file
Project20     :
Created20     :
Description20 : build Monitor20, Sequencer,Driver20 and connect Sequencer and driver
Notes20       :  
----------------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------

  
`ifndef UART_TX_AGENT_SVH20
`define UART_TX_AGENT_SVH20

class uart_tx_agent20 extends uvm_agent;

  // Active20/Passive20 Agent20 configuration
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Configuration20
  uart_config20 cfg;
  
  uart_tx_monitor20 monitor20;
  uart_tx_driver20 driver;
  uart_sequencer20 sequencer;

  // Provides20 implementation of methods20 such20 as get_type_name and create
  `uvm_component_utils_begin(uart_tx_agent20)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end 

  // Constructor20 - UVM required20 syntax20
  function new(string name = "", uvm_component parent); 
    super.new(name, parent);
  endfunction

  // Additional20 class methods20
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config20(uart_config20 cfg);
  
endclass : uart_tx_agent20

// UVM build_phase
function void uart_tx_agent20::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure20
  if (cfg == null) begin
    if (!uvm_config_db#(uart_config20)::get(this, "", "cfg", cfg))
    `uvm_warning("NOCONFIG20", "Config20 not set for Tx20 agent20, using default is_active field")
  end
  else is_active = cfg.is_tx_active20;
  monitor20 = uart_tx_monitor20::type_id::create("monitor20",this);   //lab3_note120
  if (is_active == UVM_ACTIVE) begin
    //If20 UVM_ACTIVE create instances20 of UART20 Driver20 and Sequencer
    sequencer = uart_sequencer20::type_id::create("sequencer",this);
    driver = uart_tx_driver20::type_id::create("driver",this);
  end
endfunction : build_phase

// UVM connect() phase
function void uart_tx_agent20::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (is_active == UVM_ACTIVE) begin
    // Binds20 the driver to the sequencer using TLM port connections20
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

// Assign20 the config to the agent20's children
function void uart_tx_agent20::update_config20( uart_config20 cfg);
  monitor20.cfg = cfg;
  if (is_active == UVM_ACTIVE) begin
    driver.cfg = cfg;
    sequencer.cfg = cfg;
  end
endfunction : update_config20

`endif
