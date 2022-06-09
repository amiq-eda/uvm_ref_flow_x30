/*-------------------------------------------------------------------------
File18 name   : uart_rx_agent18.sv
Title18       : Rx18 Agent18 file
Project18     :
Created18     :
Description18 : build Monitor18, Sequencer,Driver18 and connect Sequencer and driver
Notes18       :  
----------------------------------------------------------------------*/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------

  
`ifndef UART_RX_AGENT_SV18
`define UART_RX_AGENT_SV18

class uart_rx_agent18 extends uvm_agent;

  // Active18/Passive18 Agent18 configuration
  //uvm_active_passive_enum is_active = UVM_ACTIVE;
  
  // Pointer18 to the UART18 config
  uart_config18 cfg;

  uart_rx_monitor18 monitor18;
  uart_rx_driver18 driver;     
  uart_sequencer18 sequencer;

  // Provides18 implementation of methods18 such18 as get_type_name and create
  `uvm_component_utils_begin(uart_rx_agent18)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end 

  // Constructor18 - UVM required18 syntax18
  function new(string name = "", uvm_component parent); 
    super.new(name, parent);
  endfunction

  // Additional18 class methods18
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config18(uart_config18 cfg);
  
endclass : uart_rx_agent18

// UVM build_phase
function void uart_rx_agent18::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure18
  if (cfg == null) begin
    if (!uvm_config_db#(uart_config18)::get(this, "", "cfg", cfg))
    `uvm_warning("NOCONFIG18", "Config18 not set for Rx18 agent18, using default is_active field")
  end
  else is_active = cfg.is_rx_active18;

  monitor18 = uart_rx_monitor18::type_id::create("monitor18",this);
  if (is_active == UVM_ACTIVE) begin
    //If18 UVM_ACTIVE create instances18 of UART18 Driver18 and Sequencer
    sequencer = uart_sequencer18::type_id::create("sequencer",this);
    driver = uart_rx_driver18::type_id::create("driver",this);
  end
endfunction : build_phase

// UVM connect_phase
function void uart_rx_agent18::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (is_active == UVM_ACTIVE) begin
    // Binds18 the driver to the sequencer using TLM port connections18
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

// Assign18 the config to the agent18's children
function void uart_rx_agent18::update_config18( uart_config18 cfg);
  monitor18.cfg = cfg;
  if (is_active == UVM_ACTIVE) begin
    driver.cfg = cfg;
  end
endfunction : update_config18

`endif  //UART_RX_AGENT_SV18
