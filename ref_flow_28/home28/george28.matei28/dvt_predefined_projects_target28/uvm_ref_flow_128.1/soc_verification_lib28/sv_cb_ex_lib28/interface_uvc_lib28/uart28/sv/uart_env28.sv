/*-------------------------------------------------------------------------
File28 name   : uart_env28.sv
Title28       : UART28 UVC28 env28 file 
Project28     :
Created28     :
Description28 : Creates28 and configures28 the UART28 UVC28
Notes28       :  
----------------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------


`ifndef UART_ENV_SVH28
`define UART_ENV_SVH28

class uart_env28 extends uvm_env;

  // Virtual Interface28 variable
  virtual interface uart_if28 vif28;

  // Environment28 Configuration28 Paramters28
  uart_config28 cfg;         // UART28 configuration object
  bit checks_enable28 = 1;
  bit coverage_enable28 = 1;
   
  // Components of the environment28
  uart_tx_agent28 Tx28;
  uart_rx_agent28 Rx28;

  // Used28 to update the config when it is updated during simulation
  uvm_analysis_imp#(uart_config28, uart_env28) dut_cfg_port_in28;

  // This28 macro28 provide28 implementation of get_type_name() and create()
  `uvm_component_utils_begin(uart_env28)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable28, UVM_DEFAULT)
    `uvm_field_int(coverage_enable28, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor28 - required28 UVM syntax28
  function new( string name, uvm_component parent);
    super.new(name, parent);
    dut_cfg_port_in28 = new("dut_cfg_port_in28", this);
  endfunction

  // Additional28 class methods28
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables28();
  extern virtual function void write(uart_config28 cfg);
  extern virtual function void update_config28(uart_config28 cfg);

endclass : uart_env28

//UVM build_phase
function void uart_env28::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure28
  if ( cfg == null)
    if (!uvm_config_db#(uart_config28)::get(this, "", "cfg", cfg)) begin
      `uvm_info("NOCONFIG28", "No uart_config28, creating28...", UVM_MEDIUM)
      cfg = uart_config28::type_id::create("cfg", this);
      if (!cfg.randomize())
         `uvm_error("RNDFAIL28", "Could not randomize uart_config28 using default values")
      `uvm_info(get_type_name(), {"Printing28 cfg:\n", cfg.sprint()}, UVM_MEDIUM)
    end
  // Configure28 the sub-components28
  uvm_config_object::set(this, "Tx28*", "cfg", cfg);
  uvm_config_object::set(this, "Rx28*", "cfg", cfg);

  // Create28 sub-components28
  Tx28 = uart_tx_agent28::type_id::create("Tx28",this);
  Rx28 = uart_rx_agent28::type_id::create("Rx28",this);
endfunction : build_phase

//UVM connect_phase
function void uart_env28::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get28 the agent28's virtual interface if set via config
  if(!uvm_config_db#(virtual uart_if28)::get(this, "", "vif28", vif28))
    `uvm_error("NOVIF28",{"virtual interface must be set for: ",get_full_name(),".vif28"})
endfunction : connect_phase

// Function28 to assign the checks28 and coverage28 enable bits
task uart_env28::update_vif_enables28();
  // Make28 assignments28 at time 0 based on configuration
  vif28.has_checks28 <= checks_enable28;
  vif28.has_coverage <= coverage_enable28;
  forever begin
    @(checks_enable28 or coverage_enable28);
    vif28.has_checks28 <= checks_enable28;
    vif28.has_coverage <= coverage_enable28;
  end
endtask : update_vif_enables28

// UVM run_phase
task uart_env28::run_phase(uvm_phase phase);
  fork 
    update_vif_enables28(); 
  join
endtask : run_phase
  
// Update the config when RGM28 updates28?
function void uart_env28::write(input uart_config28 cfg );
  this.cfg = cfg;
  update_config28(cfg);
endfunction : write

// Update Agent28 config when config updates28
function void uart_env28::update_config28(input uart_config28 cfg );
  Tx28.update_config28(cfg);
  Rx28.update_config28(cfg);   
endfunction : update_config28

`endif
