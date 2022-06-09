/*-------------------------------------------------------------------------
File19 name   : uart_tx_agent19.sv
Title19       : Tx19 Agent19 file
Project19     :
Created19     :
Description19 : build Monitor19, Sequencer,Driver19 and connect Sequencer and driver
Notes19       :  
----------------------------------------------------------------------*/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------

  
`ifndef UART_TX_AGENT_SVH19
`define UART_TX_AGENT_SVH19

class uart_tx_agent19 extends uvm_agent;

  // Active19/Passive19 Agent19 configuration
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Configuration19
  uart_config19 cfg;
  
  uart_tx_monitor19 monitor19;
  uart_tx_driver19 driver;
  uart_sequencer19 sequencer;

  // Provides19 implementation of methods19 such19 as get_type_name and create
  `uvm_component_utils_begin(uart_tx_agent19)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end 

  // Constructor19 - UVM required19 syntax19
  function new(string name = "", uvm_component parent); 
    super.new(name, parent);
  endfunction

  // Additional19 class methods19
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config19(uart_config19 cfg);
  
endclass : uart_tx_agent19

// UVM build_phase
function void uart_tx_agent19::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure19
  if (cfg == null) begin
    if (!uvm_config_db#(uart_config19)::get(this, "", "cfg", cfg))
    `uvm_warning("NOCONFIG19", "Config19 not set for Tx19 agent19, using default is_active field")
  end
  else is_active = cfg.is_tx_active19;
  monitor19 = uart_tx_monitor19::type_id::create("monitor19",this);   //lab3_note119
  if (is_active == UVM_ACTIVE) begin
    //If19 UVM_ACTIVE create instances19 of UART19 Driver19 and Sequencer
    sequencer = uart_sequencer19::type_id::create("sequencer",this);
    driver = uart_tx_driver19::type_id::create("driver",this);
  end
endfunction : build_phase

// UVM connect() phase
function void uart_tx_agent19::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (is_active == UVM_ACTIVE) begin
    // Binds19 the driver to the sequencer using TLM port connections19
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

// Assign19 the config to the agent19's children
function void uart_tx_agent19::update_config19( uart_config19 cfg);
  monitor19.cfg = cfg;
  if (is_active == UVM_ACTIVE) begin
    driver.cfg = cfg;
    sequencer.cfg = cfg;
  end
endfunction : update_config19

`endif
