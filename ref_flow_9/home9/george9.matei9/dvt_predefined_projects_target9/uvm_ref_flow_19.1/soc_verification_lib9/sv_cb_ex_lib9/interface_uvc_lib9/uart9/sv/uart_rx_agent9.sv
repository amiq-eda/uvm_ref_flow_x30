/*-------------------------------------------------------------------------
File9 name   : uart_rx_agent9.sv
Title9       : Rx9 Agent9 file
Project9     :
Created9     :
Description9 : build Monitor9, Sequencer,Driver9 and connect Sequencer and driver
Notes9       :  
----------------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------

  
`ifndef UART_RX_AGENT_SV9
`define UART_RX_AGENT_SV9

class uart_rx_agent9 extends uvm_agent;

  // Active9/Passive9 Agent9 configuration
  //uvm_active_passive_enum is_active = UVM_ACTIVE;
  
  // Pointer9 to the UART9 config
  uart_config9 cfg;

  uart_rx_monitor9 monitor9;
  uart_rx_driver9 driver;     
  uart_sequencer9 sequencer;

  // Provides9 implementation of methods9 such9 as get_type_name and create
  `uvm_component_utils_begin(uart_rx_agent9)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end 

  // Constructor9 - UVM required9 syntax9
  function new(string name = "", uvm_component parent); 
    super.new(name, parent);
  endfunction

  // Additional9 class methods9
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config9(uart_config9 cfg);
  
endclass : uart_rx_agent9

// UVM build_phase
function void uart_rx_agent9::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure9
  if (cfg == null) begin
    if (!uvm_config_db#(uart_config9)::get(this, "", "cfg", cfg))
    `uvm_warning("NOCONFIG9", "Config9 not set for Rx9 agent9, using default is_active field")
  end
  else is_active = cfg.is_rx_active9;

  monitor9 = uart_rx_monitor9::type_id::create("monitor9",this);
  if (is_active == UVM_ACTIVE) begin
    //If9 UVM_ACTIVE create instances9 of UART9 Driver9 and Sequencer
    sequencer = uart_sequencer9::type_id::create("sequencer",this);
    driver = uart_rx_driver9::type_id::create("driver",this);
  end
endfunction : build_phase

// UVM connect_phase
function void uart_rx_agent9::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (is_active == UVM_ACTIVE) begin
    // Binds9 the driver to the sequencer using TLM port connections9
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

// Assign9 the config to the agent9's children
function void uart_rx_agent9::update_config9( uart_config9 cfg);
  monitor9.cfg = cfg;
  if (is_active == UVM_ACTIVE) begin
    driver.cfg = cfg;
  end
endfunction : update_config9

`endif  //UART_RX_AGENT_SV9
