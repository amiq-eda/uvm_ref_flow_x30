/*-------------------------------------------------------------------------
File7 name   : uart_rx_agent7.sv
Title7       : Rx7 Agent7 file
Project7     :
Created7     :
Description7 : build Monitor7, Sequencer,Driver7 and connect Sequencer and driver
Notes7       :  
----------------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------

  
`ifndef UART_RX_AGENT_SV7
`define UART_RX_AGENT_SV7

class uart_rx_agent7 extends uvm_agent;

  // Active7/Passive7 Agent7 configuration
  //uvm_active_passive_enum is_active = UVM_ACTIVE;
  
  // Pointer7 to the UART7 config
  uart_config7 cfg;

  uart_rx_monitor7 monitor7;
  uart_rx_driver7 driver;     
  uart_sequencer7 sequencer;

  // Provides7 implementation of methods7 such7 as get_type_name and create
  `uvm_component_utils_begin(uart_rx_agent7)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end 

  // Constructor7 - UVM required7 syntax7
  function new(string name = "", uvm_component parent); 
    super.new(name, parent);
  endfunction

  // Additional7 class methods7
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config7(uart_config7 cfg);
  
endclass : uart_rx_agent7

// UVM build_phase
function void uart_rx_agent7::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure7
  if (cfg == null) begin
    if (!uvm_config_db#(uart_config7)::get(this, "", "cfg", cfg))
    `uvm_warning("NOCONFIG7", "Config7 not set for Rx7 agent7, using default is_active field")
  end
  else is_active = cfg.is_rx_active7;

  monitor7 = uart_rx_monitor7::type_id::create("monitor7",this);
  if (is_active == UVM_ACTIVE) begin
    //If7 UVM_ACTIVE create instances7 of UART7 Driver7 and Sequencer
    sequencer = uart_sequencer7::type_id::create("sequencer",this);
    driver = uart_rx_driver7::type_id::create("driver",this);
  end
endfunction : build_phase

// UVM connect_phase
function void uart_rx_agent7::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (is_active == UVM_ACTIVE) begin
    // Binds7 the driver to the sequencer using TLM port connections7
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

// Assign7 the config to the agent7's children
function void uart_rx_agent7::update_config7( uart_config7 cfg);
  monitor7.cfg = cfg;
  if (is_active == UVM_ACTIVE) begin
    driver.cfg = cfg;
  end
endfunction : update_config7

`endif  //UART_RX_AGENT_SV7
