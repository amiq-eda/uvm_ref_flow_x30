/*-------------------------------------------------------------------------
File3 name   : uart_rx_agent3.sv
Title3       : Rx3 Agent3 file
Project3     :
Created3     :
Description3 : build Monitor3, Sequencer,Driver3 and connect Sequencer and driver
Notes3       :  
----------------------------------------------------------------------*/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------

  
`ifndef UART_RX_AGENT_SV3
`define UART_RX_AGENT_SV3

class uart_rx_agent3 extends uvm_agent;

  // Active3/Passive3 Agent3 configuration
  //uvm_active_passive_enum is_active = UVM_ACTIVE;
  
  // Pointer3 to the UART3 config
  uart_config3 cfg;

  uart_rx_monitor3 monitor3;
  uart_rx_driver3 driver;     
  uart_sequencer3 sequencer;

  // Provides3 implementation of methods3 such3 as get_type_name and create
  `uvm_component_utils_begin(uart_rx_agent3)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end 

  // Constructor3 - UVM required3 syntax3
  function new(string name = "", uvm_component parent); 
    super.new(name, parent);
  endfunction

  // Additional3 class methods3
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config3(uart_config3 cfg);
  
endclass : uart_rx_agent3

// UVM build_phase
function void uart_rx_agent3::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure3
  if (cfg == null) begin
    if (!uvm_config_db#(uart_config3)::get(this, "", "cfg", cfg))
    `uvm_warning("NOCONFIG3", "Config3 not set for Rx3 agent3, using default is_active field")
  end
  else is_active = cfg.is_rx_active3;

  monitor3 = uart_rx_monitor3::type_id::create("monitor3",this);
  if (is_active == UVM_ACTIVE) begin
    //If3 UVM_ACTIVE create instances3 of UART3 Driver3 and Sequencer
    sequencer = uart_sequencer3::type_id::create("sequencer",this);
    driver = uart_rx_driver3::type_id::create("driver",this);
  end
endfunction : build_phase

// UVM connect_phase
function void uart_rx_agent3::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (is_active == UVM_ACTIVE) begin
    // Binds3 the driver to the sequencer using TLM port connections3
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

// Assign3 the config to the agent3's children
function void uart_rx_agent3::update_config3( uart_config3 cfg);
  monitor3.cfg = cfg;
  if (is_active == UVM_ACTIVE) begin
    driver.cfg = cfg;
  end
endfunction : update_config3

`endif  //UART_RX_AGENT_SV3
