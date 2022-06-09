/*-------------------------------------------------------------------------
File22 name   : uart_env22.sv
Title22       : UART22 UVC22 env22 file 
Project22     :
Created22     :
Description22 : Creates22 and configures22 the UART22 UVC22
Notes22       :  
----------------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------


`ifndef UART_ENV_SVH22
`define UART_ENV_SVH22

class uart_env22 extends uvm_env;

  // Virtual Interface22 variable
  virtual interface uart_if22 vif22;

  // Environment22 Configuration22 Paramters22
  uart_config22 cfg;         // UART22 configuration object
  bit checks_enable22 = 1;
  bit coverage_enable22 = 1;
   
  // Components of the environment22
  uart_tx_agent22 Tx22;
  uart_rx_agent22 Rx22;

  // Used22 to update the config when it is updated during simulation
  uvm_analysis_imp#(uart_config22, uart_env22) dut_cfg_port_in22;

  // This22 macro22 provide22 implementation of get_type_name() and create()
  `uvm_component_utils_begin(uart_env22)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable22, UVM_DEFAULT)
    `uvm_field_int(coverage_enable22, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor22 - required22 UVM syntax22
  function new( string name, uvm_component parent);
    super.new(name, parent);
    dut_cfg_port_in22 = new("dut_cfg_port_in22", this);
  endfunction

  // Additional22 class methods22
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables22();
  extern virtual function void write(uart_config22 cfg);
  extern virtual function void update_config22(uart_config22 cfg);

endclass : uart_env22

//UVM build_phase
function void uart_env22::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure22
  if ( cfg == null)
    if (!uvm_config_db#(uart_config22)::get(this, "", "cfg", cfg)) begin
      `uvm_info("NOCONFIG22", "No uart_config22, creating22...", UVM_MEDIUM)
      cfg = uart_config22::type_id::create("cfg", this);
      if (!cfg.randomize())
         `uvm_error("RNDFAIL22", "Could not randomize uart_config22 using default values")
      `uvm_info(get_type_name(), {"Printing22 cfg:\n", cfg.sprint()}, UVM_MEDIUM)
    end
  // Configure22 the sub-components22
  uvm_config_object::set(this, "Tx22*", "cfg", cfg);
  uvm_config_object::set(this, "Rx22*", "cfg", cfg);

  // Create22 sub-components22
  Tx22 = uart_tx_agent22::type_id::create("Tx22",this);
  Rx22 = uart_rx_agent22::type_id::create("Rx22",this);
endfunction : build_phase

//UVM connect_phase
function void uart_env22::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get22 the agent22's virtual interface if set via config
  if(!uvm_config_db#(virtual uart_if22)::get(this, "", "vif22", vif22))
    `uvm_error("NOVIF22",{"virtual interface must be set for: ",get_full_name(),".vif22"})
endfunction : connect_phase

// Function22 to assign the checks22 and coverage22 enable bits
task uart_env22::update_vif_enables22();
  // Make22 assignments22 at time 0 based on configuration
  vif22.has_checks22 <= checks_enable22;
  vif22.has_coverage <= coverage_enable22;
  forever begin
    @(checks_enable22 or coverage_enable22);
    vif22.has_checks22 <= checks_enable22;
    vif22.has_coverage <= coverage_enable22;
  end
endtask : update_vif_enables22

// UVM run_phase
task uart_env22::run_phase(uvm_phase phase);
  fork 
    update_vif_enables22(); 
  join
endtask : run_phase
  
// Update the config when RGM22 updates22?
function void uart_env22::write(input uart_config22 cfg );
  this.cfg = cfg;
  update_config22(cfg);
endfunction : write

// Update Agent22 config when config updates22
function void uart_env22::update_config22(input uart_config22 cfg );
  Tx22.update_config22(cfg);
  Rx22.update_config22(cfg);   
endfunction : update_config22

`endif
