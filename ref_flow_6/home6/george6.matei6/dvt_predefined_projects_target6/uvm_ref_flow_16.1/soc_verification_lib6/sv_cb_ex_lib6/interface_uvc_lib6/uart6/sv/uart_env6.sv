/*-------------------------------------------------------------------------
File6 name   : uart_env6.sv
Title6       : UART6 UVC6 env6 file 
Project6     :
Created6     :
Description6 : Creates6 and configures6 the UART6 UVC6
Notes6       :  
----------------------------------------------------------------------*/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------


`ifndef UART_ENV_SVH6
`define UART_ENV_SVH6

class uart_env6 extends uvm_env;

  // Virtual Interface6 variable
  virtual interface uart_if6 vif6;

  // Environment6 Configuration6 Paramters6
  uart_config6 cfg;         // UART6 configuration object
  bit checks_enable6 = 1;
  bit coverage_enable6 = 1;
   
  // Components of the environment6
  uart_tx_agent6 Tx6;
  uart_rx_agent6 Rx6;

  // Used6 to update the config when it is updated during simulation
  uvm_analysis_imp#(uart_config6, uart_env6) dut_cfg_port_in6;

  // This6 macro6 provide6 implementation of get_type_name() and create()
  `uvm_component_utils_begin(uart_env6)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable6, UVM_DEFAULT)
    `uvm_field_int(coverage_enable6, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor6 - required6 UVM syntax6
  function new( string name, uvm_component parent);
    super.new(name, parent);
    dut_cfg_port_in6 = new("dut_cfg_port_in6", this);
  endfunction

  // Additional6 class methods6
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables6();
  extern virtual function void write(uart_config6 cfg);
  extern virtual function void update_config6(uart_config6 cfg);

endclass : uart_env6

//UVM build_phase
function void uart_env6::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure6
  if ( cfg == null)
    if (!uvm_config_db#(uart_config6)::get(this, "", "cfg", cfg)) begin
      `uvm_info("NOCONFIG6", "No uart_config6, creating6...", UVM_MEDIUM)
      cfg = uart_config6::type_id::create("cfg", this);
      if (!cfg.randomize())
         `uvm_error("RNDFAIL6", "Could not randomize uart_config6 using default values")
      `uvm_info(get_type_name(), {"Printing6 cfg:\n", cfg.sprint()}, UVM_MEDIUM)
    end
  // Configure6 the sub-components6
  uvm_config_object::set(this, "Tx6*", "cfg", cfg);
  uvm_config_object::set(this, "Rx6*", "cfg", cfg);

  // Create6 sub-components6
  Tx6 = uart_tx_agent6::type_id::create("Tx6",this);
  Rx6 = uart_rx_agent6::type_id::create("Rx6",this);
endfunction : build_phase

//UVM connect_phase
function void uart_env6::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get6 the agent6's virtual interface if set via config
  if(!uvm_config_db#(virtual uart_if6)::get(this, "", "vif6", vif6))
    `uvm_error("NOVIF6",{"virtual interface must be set for: ",get_full_name(),".vif6"})
endfunction : connect_phase

// Function6 to assign the checks6 and coverage6 enable bits
task uart_env6::update_vif_enables6();
  // Make6 assignments6 at time 0 based on configuration
  vif6.has_checks6 <= checks_enable6;
  vif6.has_coverage <= coverage_enable6;
  forever begin
    @(checks_enable6 or coverage_enable6);
    vif6.has_checks6 <= checks_enable6;
    vif6.has_coverage <= coverage_enable6;
  end
endtask : update_vif_enables6

// UVM run_phase
task uart_env6::run_phase(uvm_phase phase);
  fork 
    update_vif_enables6(); 
  join
endtask : run_phase
  
// Update the config when RGM6 updates6?
function void uart_env6::write(input uart_config6 cfg );
  this.cfg = cfg;
  update_config6(cfg);
endfunction : write

// Update Agent6 config when config updates6
function void uart_env6::update_config6(input uart_config6 cfg );
  Tx6.update_config6(cfg);
  Rx6.update_config6(cfg);   
endfunction : update_config6

`endif
