/*-------------------------------------------------------------------------
File2 name   : uart_tx_agent2.sv
Title2       : Tx2 Agent2 file
Project2     :
Created2     :
Description2 : build Monitor2, Sequencer,Driver2 and connect Sequencer and driver
Notes2       :  
----------------------------------------------------------------------*/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------

  
`ifndef UART_TX_AGENT_SVH2
`define UART_TX_AGENT_SVH2

class uart_tx_agent2 extends uvm_agent;

  // Active2/Passive2 Agent2 configuration
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Configuration2
  uart_config2 cfg;
  
  uart_tx_monitor2 monitor2;
  uart_tx_driver2 driver;
  uart_sequencer2 sequencer;

  // Provides2 implementation of methods2 such2 as get_type_name and create
  `uvm_component_utils_begin(uart_tx_agent2)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end 

  // Constructor2 - UVM required2 syntax2
  function new(string name = "", uvm_component parent); 
    super.new(name, parent);
  endfunction

  // Additional2 class methods2
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config2(uart_config2 cfg);
  
endclass : uart_tx_agent2

// UVM build_phase
function void uart_tx_agent2::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure2
  if (cfg == null) begin
    if (!uvm_config_db#(uart_config2)::get(this, "", "cfg", cfg))
    `uvm_warning("NOCONFIG2", "Config2 not set for Tx2 agent2, using default is_active field")
  end
  else is_active = cfg.is_tx_active2;
  monitor2 = uart_tx_monitor2::type_id::create("monitor2",this);   //lab3_note12
  if (is_active == UVM_ACTIVE) begin
    //If2 UVM_ACTIVE create instances2 of UART2 Driver2 and Sequencer
    sequencer = uart_sequencer2::type_id::create("sequencer",this);
    driver = uart_tx_driver2::type_id::create("driver",this);
  end
endfunction : build_phase

// UVM connect() phase
function void uart_tx_agent2::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (is_active == UVM_ACTIVE) begin
    // Binds2 the driver to the sequencer using TLM port connections2
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

// Assign2 the config to the agent2's children
function void uart_tx_agent2::update_config2( uart_config2 cfg);
  monitor2.cfg = cfg;
  if (is_active == UVM_ACTIVE) begin
    driver.cfg = cfg;
    sequencer.cfg = cfg;
  end
endfunction : update_config2

`endif
