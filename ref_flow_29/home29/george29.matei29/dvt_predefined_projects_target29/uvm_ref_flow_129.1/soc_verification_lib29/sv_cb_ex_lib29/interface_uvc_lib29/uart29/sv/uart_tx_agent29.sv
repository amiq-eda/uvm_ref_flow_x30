/*-------------------------------------------------------------------------
File29 name   : uart_tx_agent29.sv
Title29       : Tx29 Agent29 file
Project29     :
Created29     :
Description29 : build Monitor29, Sequencer,Driver29 and connect Sequencer and driver
Notes29       :  
----------------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------

  
`ifndef UART_TX_AGENT_SVH29
`define UART_TX_AGENT_SVH29

class uart_tx_agent29 extends uvm_agent;

  // Active29/Passive29 Agent29 configuration
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Configuration29
  uart_config29 cfg;
  
  uart_tx_monitor29 monitor29;
  uart_tx_driver29 driver;
  uart_sequencer29 sequencer;

  // Provides29 implementation of methods29 such29 as get_type_name and create
  `uvm_component_utils_begin(uart_tx_agent29)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end 

  // Constructor29 - UVM required29 syntax29
  function new(string name = "", uvm_component parent); 
    super.new(name, parent);
  endfunction

  // Additional29 class methods29
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config29(uart_config29 cfg);
  
endclass : uart_tx_agent29

// UVM build_phase
function void uart_tx_agent29::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure29
  if (cfg == null) begin
    if (!uvm_config_db#(uart_config29)::get(this, "", "cfg", cfg))
    `uvm_warning("NOCONFIG29", "Config29 not set for Tx29 agent29, using default is_active field")
  end
  else is_active = cfg.is_tx_active29;
  monitor29 = uart_tx_monitor29::type_id::create("monitor29",this);   //lab3_note129
  if (is_active == UVM_ACTIVE) begin
    //If29 UVM_ACTIVE create instances29 of UART29 Driver29 and Sequencer
    sequencer = uart_sequencer29::type_id::create("sequencer",this);
    driver = uart_tx_driver29::type_id::create("driver",this);
  end
endfunction : build_phase

// UVM connect() phase
function void uart_tx_agent29::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (is_active == UVM_ACTIVE) begin
    // Binds29 the driver to the sequencer using TLM port connections29
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

// Assign29 the config to the agent29's children
function void uart_tx_agent29::update_config29( uart_config29 cfg);
  monitor29.cfg = cfg;
  if (is_active == UVM_ACTIVE) begin
    driver.cfg = cfg;
    sequencer.cfg = cfg;
  end
endfunction : update_config29

`endif
