/*-------------------------------------------------------------------------
File30 name   : uart_rx_agent30.sv
Title30       : Rx30 Agent30 file
Project30     :
Created30     :
Description30 : build Monitor30, Sequencer,Driver30 and connect Sequencer and driver
Notes30       :  
----------------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------

  
`ifndef UART_RX_AGENT_SV30
`define UART_RX_AGENT_SV30

class uart_rx_agent30 extends uvm_agent;

  // Active30/Passive30 Agent30 configuration
  //uvm_active_passive_enum is_active = UVM_ACTIVE;
  
  // Pointer30 to the UART30 config
  uart_config30 cfg;

  uart_rx_monitor30 monitor30;
  uart_rx_driver30 driver;     
  uart_sequencer30 sequencer;

  // Provides30 implementation of methods30 such30 as get_type_name and create
  `uvm_component_utils_begin(uart_rx_agent30)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end 

  // Constructor30 - UVM required30 syntax30
  function new(string name = "", uvm_component parent); 
    super.new(name, parent);
  endfunction

  // Additional30 class methods30
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config30(uart_config30 cfg);
  
endclass : uart_rx_agent30

// UVM build_phase
function void uart_rx_agent30::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure30
  if (cfg == null) begin
    if (!uvm_config_db#(uart_config30)::get(this, "", "cfg", cfg))
    `uvm_warning("NOCONFIG30", "Config30 not set for Rx30 agent30, using default is_active field")
  end
  else is_active = cfg.is_rx_active30;

  monitor30 = uart_rx_monitor30::type_id::create("monitor30",this);
  if (is_active == UVM_ACTIVE) begin
    //If30 UVM_ACTIVE create instances30 of UART30 Driver30 and Sequencer
    sequencer = uart_sequencer30::type_id::create("sequencer",this);
    driver = uart_rx_driver30::type_id::create("driver",this);
  end
endfunction : build_phase

// UVM connect_phase
function void uart_rx_agent30::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (is_active == UVM_ACTIVE) begin
    // Binds30 the driver to the sequencer using TLM port connections30
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

// Assign30 the config to the agent30's children
function void uart_rx_agent30::update_config30( uart_config30 cfg);
  monitor30.cfg = cfg;
  if (is_active == UVM_ACTIVE) begin
    driver.cfg = cfg;
  end
endfunction : update_config30

`endif  //UART_RX_AGENT_SV30
