/*-------------------------------------------------------------------------
File4 name   : uart_tx_agent4.sv
Title4       : Tx4 Agent4 file
Project4     :
Created4     :
Description4 : build Monitor4, Sequencer,Driver4 and connect Sequencer and driver
Notes4       :  
----------------------------------------------------------------------*/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------

  
`ifndef UART_TX_AGENT_SVH4
`define UART_TX_AGENT_SVH4

class uart_tx_agent4 extends uvm_agent;

  // Active4/Passive4 Agent4 configuration
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Configuration4
  uart_config4 cfg;
  
  uart_tx_monitor4 monitor4;
  uart_tx_driver4 driver;
  uart_sequencer4 sequencer;

  // Provides4 implementation of methods4 such4 as get_type_name and create
  `uvm_component_utils_begin(uart_tx_agent4)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end 

  // Constructor4 - UVM required4 syntax4
  function new(string name = "", uvm_component parent); 
    super.new(name, parent);
  endfunction

  // Additional4 class methods4
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config4(uart_config4 cfg);
  
endclass : uart_tx_agent4

// UVM build_phase
function void uart_tx_agent4::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure4
  if (cfg == null) begin
    if (!uvm_config_db#(uart_config4)::get(this, "", "cfg", cfg))
    `uvm_warning("NOCONFIG4", "Config4 not set for Tx4 agent4, using default is_active field")
  end
  else is_active = cfg.is_tx_active4;
  monitor4 = uart_tx_monitor4::type_id::create("monitor4",this);   //lab3_note14
  if (is_active == UVM_ACTIVE) begin
    //If4 UVM_ACTIVE create instances4 of UART4 Driver4 and Sequencer
    sequencer = uart_sequencer4::type_id::create("sequencer",this);
    driver = uart_tx_driver4::type_id::create("driver",this);
  end
endfunction : build_phase

// UVM connect() phase
function void uart_tx_agent4::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (is_active == UVM_ACTIVE) begin
    // Binds4 the driver to the sequencer using TLM port connections4
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

// Assign4 the config to the agent4's children
function void uart_tx_agent4::update_config4( uart_config4 cfg);
  monitor4.cfg = cfg;
  if (is_active == UVM_ACTIVE) begin
    driver.cfg = cfg;
    sequencer.cfg = cfg;
  end
endfunction : update_config4

`endif
