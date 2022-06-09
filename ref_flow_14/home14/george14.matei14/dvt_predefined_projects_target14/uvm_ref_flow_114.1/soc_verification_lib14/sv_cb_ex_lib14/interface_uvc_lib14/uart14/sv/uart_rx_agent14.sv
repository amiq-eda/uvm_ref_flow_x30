/*-------------------------------------------------------------------------
File14 name   : uart_rx_agent14.sv
Title14       : Rx14 Agent14 file
Project14     :
Created14     :
Description14 : build Monitor14, Sequencer,Driver14 and connect Sequencer and driver
Notes14       :  
----------------------------------------------------------------------*/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------

  
`ifndef UART_RX_AGENT_SV14
`define UART_RX_AGENT_SV14

class uart_rx_agent14 extends uvm_agent;

  // Active14/Passive14 Agent14 configuration
  //uvm_active_passive_enum is_active = UVM_ACTIVE;
  
  // Pointer14 to the UART14 config
  uart_config14 cfg;

  uart_rx_monitor14 monitor14;
  uart_rx_driver14 driver;     
  uart_sequencer14 sequencer;

  // Provides14 implementation of methods14 such14 as get_type_name and create
  `uvm_component_utils_begin(uart_rx_agent14)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end 

  // Constructor14 - UVM required14 syntax14
  function new(string name = "", uvm_component parent); 
    super.new(name, parent);
  endfunction

  // Additional14 class methods14
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config14(uart_config14 cfg);
  
endclass : uart_rx_agent14

// UVM build_phase
function void uart_rx_agent14::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure14
  if (cfg == null) begin
    if (!uvm_config_db#(uart_config14)::get(this, "", "cfg", cfg))
    `uvm_warning("NOCONFIG14", "Config14 not set for Rx14 agent14, using default is_active field")
  end
  else is_active = cfg.is_rx_active14;

  monitor14 = uart_rx_monitor14::type_id::create("monitor14",this);
  if (is_active == UVM_ACTIVE) begin
    //If14 UVM_ACTIVE create instances14 of UART14 Driver14 and Sequencer
    sequencer = uart_sequencer14::type_id::create("sequencer",this);
    driver = uart_rx_driver14::type_id::create("driver",this);
  end
endfunction : build_phase

// UVM connect_phase
function void uart_rx_agent14::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (is_active == UVM_ACTIVE) begin
    // Binds14 the driver to the sequencer using TLM port connections14
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

// Assign14 the config to the agent14's children
function void uart_rx_agent14::update_config14( uart_config14 cfg);
  monitor14.cfg = cfg;
  if (is_active == UVM_ACTIVE) begin
    driver.cfg = cfg;
  end
endfunction : update_config14

`endif  //UART_RX_AGENT_SV14
