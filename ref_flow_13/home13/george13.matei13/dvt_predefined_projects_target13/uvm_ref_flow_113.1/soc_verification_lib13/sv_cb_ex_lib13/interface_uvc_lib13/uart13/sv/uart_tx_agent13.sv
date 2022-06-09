/*-------------------------------------------------------------------------
File13 name   : uart_tx_agent13.sv
Title13       : Tx13 Agent13 file
Project13     :
Created13     :
Description13 : build Monitor13, Sequencer,Driver13 and connect Sequencer and driver
Notes13       :  
----------------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------

  
`ifndef UART_TX_AGENT_SVH13
`define UART_TX_AGENT_SVH13

class uart_tx_agent13 extends uvm_agent;

  // Active13/Passive13 Agent13 configuration
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Configuration13
  uart_config13 cfg;
  
  uart_tx_monitor13 monitor13;
  uart_tx_driver13 driver;
  uart_sequencer13 sequencer;

  // Provides13 implementation of methods13 such13 as get_type_name and create
  `uvm_component_utils_begin(uart_tx_agent13)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end 

  // Constructor13 - UVM required13 syntax13
  function new(string name = "", uvm_component parent); 
    super.new(name, parent);
  endfunction

  // Additional13 class methods13
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config13(uart_config13 cfg);
  
endclass : uart_tx_agent13

// UVM build_phase
function void uart_tx_agent13::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure13
  if (cfg == null) begin
    if (!uvm_config_db#(uart_config13)::get(this, "", "cfg", cfg))
    `uvm_warning("NOCONFIG13", "Config13 not set for Tx13 agent13, using default is_active field")
  end
  else is_active = cfg.is_tx_active13;
  monitor13 = uart_tx_monitor13::type_id::create("monitor13",this);   //lab3_note113
  if (is_active == UVM_ACTIVE) begin
    //If13 UVM_ACTIVE create instances13 of UART13 Driver13 and Sequencer
    sequencer = uart_sequencer13::type_id::create("sequencer",this);
    driver = uart_tx_driver13::type_id::create("driver",this);
  end
endfunction : build_phase

// UVM connect() phase
function void uart_tx_agent13::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (is_active == UVM_ACTIVE) begin
    // Binds13 the driver to the sequencer using TLM port connections13
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

// Assign13 the config to the agent13's children
function void uart_tx_agent13::update_config13( uart_config13 cfg);
  monitor13.cfg = cfg;
  if (is_active == UVM_ACTIVE) begin
    driver.cfg = cfg;
    sequencer.cfg = cfg;
  end
endfunction : update_config13

`endif
