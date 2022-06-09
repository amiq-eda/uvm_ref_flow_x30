/*-------------------------------------------------------------------------
File16 name   : uart_rx_agent16.sv
Title16       : Rx16 Agent16 file
Project16     :
Created16     :
Description16 : build Monitor16, Sequencer,Driver16 and connect Sequencer and driver
Notes16       :  
----------------------------------------------------------------------*/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------

  
`ifndef UART_RX_AGENT_SV16
`define UART_RX_AGENT_SV16

class uart_rx_agent16 extends uvm_agent;

  // Active16/Passive16 Agent16 configuration
  //uvm_active_passive_enum is_active = UVM_ACTIVE;
  
  // Pointer16 to the UART16 config
  uart_config16 cfg;

  uart_rx_monitor16 monitor16;
  uart_rx_driver16 driver;     
  uart_sequencer16 sequencer;

  // Provides16 implementation of methods16 such16 as get_type_name and create
  `uvm_component_utils_begin(uart_rx_agent16)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end 

  // Constructor16 - UVM required16 syntax16
  function new(string name = "", uvm_component parent); 
    super.new(name, parent);
  endfunction

  // Additional16 class methods16
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config16(uart_config16 cfg);
  
endclass : uart_rx_agent16

// UVM build_phase
function void uart_rx_agent16::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure16
  if (cfg == null) begin
    if (!uvm_config_db#(uart_config16)::get(this, "", "cfg", cfg))
    `uvm_warning("NOCONFIG16", "Config16 not set for Rx16 agent16, using default is_active field")
  end
  else is_active = cfg.is_rx_active16;

  monitor16 = uart_rx_monitor16::type_id::create("monitor16",this);
  if (is_active == UVM_ACTIVE) begin
    //If16 UVM_ACTIVE create instances16 of UART16 Driver16 and Sequencer
    sequencer = uart_sequencer16::type_id::create("sequencer",this);
    driver = uart_rx_driver16::type_id::create("driver",this);
  end
endfunction : build_phase

// UVM connect_phase
function void uart_rx_agent16::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (is_active == UVM_ACTIVE) begin
    // Binds16 the driver to the sequencer using TLM port connections16
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

// Assign16 the config to the agent16's children
function void uart_rx_agent16::update_config16( uart_config16 cfg);
  monitor16.cfg = cfg;
  if (is_active == UVM_ACTIVE) begin
    driver.cfg = cfg;
  end
endfunction : update_config16

`endif  //UART_RX_AGENT_SV16
