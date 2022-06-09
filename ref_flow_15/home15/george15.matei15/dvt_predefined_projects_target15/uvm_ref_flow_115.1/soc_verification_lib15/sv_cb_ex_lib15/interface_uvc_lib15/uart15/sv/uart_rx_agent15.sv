/*-------------------------------------------------------------------------
File15 name   : uart_rx_agent15.sv
Title15       : Rx15 Agent15 file
Project15     :
Created15     :
Description15 : build Monitor15, Sequencer,Driver15 and connect Sequencer and driver
Notes15       :  
----------------------------------------------------------------------*/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------

  
`ifndef UART_RX_AGENT_SV15
`define UART_RX_AGENT_SV15

class uart_rx_agent15 extends uvm_agent;

  // Active15/Passive15 Agent15 configuration
  //uvm_active_passive_enum is_active = UVM_ACTIVE;
  
  // Pointer15 to the UART15 config
  uart_config15 cfg;

  uart_rx_monitor15 monitor15;
  uart_rx_driver15 driver;     
  uart_sequencer15 sequencer;

  // Provides15 implementation of methods15 such15 as get_type_name and create
  `uvm_component_utils_begin(uart_rx_agent15)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end 

  // Constructor15 - UVM required15 syntax15
  function new(string name = "", uvm_component parent); 
    super.new(name, parent);
  endfunction

  // Additional15 class methods15
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config15(uart_config15 cfg);
  
endclass : uart_rx_agent15

// UVM build_phase
function void uart_rx_agent15::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure15
  if (cfg == null) begin
    if (!uvm_config_db#(uart_config15)::get(this, "", "cfg", cfg))
    `uvm_warning("NOCONFIG15", "Config15 not set for Rx15 agent15, using default is_active field")
  end
  else is_active = cfg.is_rx_active15;

  monitor15 = uart_rx_monitor15::type_id::create("monitor15",this);
  if (is_active == UVM_ACTIVE) begin
    //If15 UVM_ACTIVE create instances15 of UART15 Driver15 and Sequencer
    sequencer = uart_sequencer15::type_id::create("sequencer",this);
    driver = uart_rx_driver15::type_id::create("driver",this);
  end
endfunction : build_phase

// UVM connect_phase
function void uart_rx_agent15::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (is_active == UVM_ACTIVE) begin
    // Binds15 the driver to the sequencer using TLM port connections15
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

// Assign15 the config to the agent15's children
function void uart_rx_agent15::update_config15( uart_config15 cfg);
  monitor15.cfg = cfg;
  if (is_active == UVM_ACTIVE) begin
    driver.cfg = cfg;
  end
endfunction : update_config15

`endif  //UART_RX_AGENT_SV15
