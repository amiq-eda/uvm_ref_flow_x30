/*-------------------------------------------------------------------------
File12 name   : uart_rx_agent12.sv
Title12       : Rx12 Agent12 file
Project12     :
Created12     :
Description12 : build Monitor12, Sequencer,Driver12 and connect Sequencer and driver
Notes12       :  
----------------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------

  
`ifndef UART_RX_AGENT_SV12
`define UART_RX_AGENT_SV12

class uart_rx_agent12 extends uvm_agent;

  // Active12/Passive12 Agent12 configuration
  //uvm_active_passive_enum is_active = UVM_ACTIVE;
  
  // Pointer12 to the UART12 config
  uart_config12 cfg;

  uart_rx_monitor12 monitor12;
  uart_rx_driver12 driver;     
  uart_sequencer12 sequencer;

  // Provides12 implementation of methods12 such12 as get_type_name and create
  `uvm_component_utils_begin(uart_rx_agent12)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end 

  // Constructor12 - UVM required12 syntax12
  function new(string name = "", uvm_component parent); 
    super.new(name, parent);
  endfunction

  // Additional12 class methods12
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config12(uart_config12 cfg);
  
endclass : uart_rx_agent12

// UVM build_phase
function void uart_rx_agent12::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure12
  if (cfg == null) begin
    if (!uvm_config_db#(uart_config12)::get(this, "", "cfg", cfg))
    `uvm_warning("NOCONFIG12", "Config12 not set for Rx12 agent12, using default is_active field")
  end
  else is_active = cfg.is_rx_active12;

  monitor12 = uart_rx_monitor12::type_id::create("monitor12",this);
  if (is_active == UVM_ACTIVE) begin
    //If12 UVM_ACTIVE create instances12 of UART12 Driver12 and Sequencer
    sequencer = uart_sequencer12::type_id::create("sequencer",this);
    driver = uart_rx_driver12::type_id::create("driver",this);
  end
endfunction : build_phase

// UVM connect_phase
function void uart_rx_agent12::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (is_active == UVM_ACTIVE) begin
    // Binds12 the driver to the sequencer using TLM port connections12
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

// Assign12 the config to the agent12's children
function void uart_rx_agent12::update_config12( uart_config12 cfg);
  monitor12.cfg = cfg;
  if (is_active == UVM_ACTIVE) begin
    driver.cfg = cfg;
  end
endfunction : update_config12

`endif  //UART_RX_AGENT_SV12
