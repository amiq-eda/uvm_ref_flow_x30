/*-------------------------------------------------------------------------
File27 name   : uart_env27.sv
Title27       : UART27 UVC27 env27 file 
Project27     :
Created27     :
Description27 : Creates27 and configures27 the UART27 UVC27
Notes27       :  
----------------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


`ifndef UART_ENV_SVH27
`define UART_ENV_SVH27

class uart_env27 extends uvm_env;

  // Virtual Interface27 variable
  virtual interface uart_if27 vif27;

  // Environment27 Configuration27 Paramters27
  uart_config27 cfg;         // UART27 configuration object
  bit checks_enable27 = 1;
  bit coverage_enable27 = 1;
   
  // Components of the environment27
  uart_tx_agent27 Tx27;
  uart_rx_agent27 Rx27;

  // Used27 to update the config when it is updated during simulation
  uvm_analysis_imp#(uart_config27, uart_env27) dut_cfg_port_in27;

  // This27 macro27 provide27 implementation of get_type_name() and create()
  `uvm_component_utils_begin(uart_env27)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable27, UVM_DEFAULT)
    `uvm_field_int(coverage_enable27, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor27 - required27 UVM syntax27
  function new( string name, uvm_component parent);
    super.new(name, parent);
    dut_cfg_port_in27 = new("dut_cfg_port_in27", this);
  endfunction

  // Additional27 class methods27
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables27();
  extern virtual function void write(uart_config27 cfg);
  extern virtual function void update_config27(uart_config27 cfg);

endclass : uart_env27

//UVM build_phase
function void uart_env27::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure27
  if ( cfg == null)
    if (!uvm_config_db#(uart_config27)::get(this, "", "cfg", cfg)) begin
      `uvm_info("NOCONFIG27", "No uart_config27, creating27...", UVM_MEDIUM)
      cfg = uart_config27::type_id::create("cfg", this);
      if (!cfg.randomize())
         `uvm_error("RNDFAIL27", "Could not randomize uart_config27 using default values")
      `uvm_info(get_type_name(), {"Printing27 cfg:\n", cfg.sprint()}, UVM_MEDIUM)
    end
  // Configure27 the sub-components27
  uvm_config_object::set(this, "Tx27*", "cfg", cfg);
  uvm_config_object::set(this, "Rx27*", "cfg", cfg);

  // Create27 sub-components27
  Tx27 = uart_tx_agent27::type_id::create("Tx27",this);
  Rx27 = uart_rx_agent27::type_id::create("Rx27",this);
endfunction : build_phase

//UVM connect_phase
function void uart_env27::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get27 the agent27's virtual interface if set via config
  if(!uvm_config_db#(virtual uart_if27)::get(this, "", "vif27", vif27))
    `uvm_error("NOVIF27",{"virtual interface must be set for: ",get_full_name(),".vif27"})
endfunction : connect_phase

// Function27 to assign the checks27 and coverage27 enable bits
task uart_env27::update_vif_enables27();
  // Make27 assignments27 at time 0 based on configuration
  vif27.has_checks27 <= checks_enable27;
  vif27.has_coverage <= coverage_enable27;
  forever begin
    @(checks_enable27 or coverage_enable27);
    vif27.has_checks27 <= checks_enable27;
    vif27.has_coverage <= coverage_enable27;
  end
endtask : update_vif_enables27

// UVM run_phase
task uart_env27::run_phase(uvm_phase phase);
  fork 
    update_vif_enables27(); 
  join
endtask : run_phase
  
// Update the config when RGM27 updates27?
function void uart_env27::write(input uart_config27 cfg );
  this.cfg = cfg;
  update_config27(cfg);
endfunction : write

// Update Agent27 config when config updates27
function void uart_env27::update_config27(input uart_config27 cfg );
  Tx27.update_config27(cfg);
  Rx27.update_config27(cfg);   
endfunction : update_config27

`endif
