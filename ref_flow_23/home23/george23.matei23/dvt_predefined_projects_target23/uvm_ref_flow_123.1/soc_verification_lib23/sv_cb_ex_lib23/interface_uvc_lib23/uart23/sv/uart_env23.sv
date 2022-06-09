/*-------------------------------------------------------------------------
File23 name   : uart_env23.sv
Title23       : UART23 UVC23 env23 file 
Project23     :
Created23     :
Description23 : Creates23 and configures23 the UART23 UVC23
Notes23       :  
----------------------------------------------------------------------*/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------


`ifndef UART_ENV_SVH23
`define UART_ENV_SVH23

class uart_env23 extends uvm_env;

  // Virtual Interface23 variable
  virtual interface uart_if23 vif23;

  // Environment23 Configuration23 Paramters23
  uart_config23 cfg;         // UART23 configuration object
  bit checks_enable23 = 1;
  bit coverage_enable23 = 1;
   
  // Components of the environment23
  uart_tx_agent23 Tx23;
  uart_rx_agent23 Rx23;

  // Used23 to update the config when it is updated during simulation
  uvm_analysis_imp#(uart_config23, uart_env23) dut_cfg_port_in23;

  // This23 macro23 provide23 implementation of get_type_name() and create()
  `uvm_component_utils_begin(uart_env23)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable23, UVM_DEFAULT)
    `uvm_field_int(coverage_enable23, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor23 - required23 UVM syntax23
  function new( string name, uvm_component parent);
    super.new(name, parent);
    dut_cfg_port_in23 = new("dut_cfg_port_in23", this);
  endfunction

  // Additional23 class methods23
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables23();
  extern virtual function void write(uart_config23 cfg);
  extern virtual function void update_config23(uart_config23 cfg);

endclass : uart_env23

//UVM build_phase
function void uart_env23::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure23
  if ( cfg == null)
    if (!uvm_config_db#(uart_config23)::get(this, "", "cfg", cfg)) begin
      `uvm_info("NOCONFIG23", "No uart_config23, creating23...", UVM_MEDIUM)
      cfg = uart_config23::type_id::create("cfg", this);
      if (!cfg.randomize())
         `uvm_error("RNDFAIL23", "Could not randomize uart_config23 using default values")
      `uvm_info(get_type_name(), {"Printing23 cfg:\n", cfg.sprint()}, UVM_MEDIUM)
    end
  // Configure23 the sub-components23
  uvm_config_object::set(this, "Tx23*", "cfg", cfg);
  uvm_config_object::set(this, "Rx23*", "cfg", cfg);

  // Create23 sub-components23
  Tx23 = uart_tx_agent23::type_id::create("Tx23",this);
  Rx23 = uart_rx_agent23::type_id::create("Rx23",this);
endfunction : build_phase

//UVM connect_phase
function void uart_env23::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get23 the agent23's virtual interface if set via config
  if(!uvm_config_db#(virtual uart_if23)::get(this, "", "vif23", vif23))
    `uvm_error("NOVIF23",{"virtual interface must be set for: ",get_full_name(),".vif23"})
endfunction : connect_phase

// Function23 to assign the checks23 and coverage23 enable bits
task uart_env23::update_vif_enables23();
  // Make23 assignments23 at time 0 based on configuration
  vif23.has_checks23 <= checks_enable23;
  vif23.has_coverage <= coverage_enable23;
  forever begin
    @(checks_enable23 or coverage_enable23);
    vif23.has_checks23 <= checks_enable23;
    vif23.has_coverage <= coverage_enable23;
  end
endtask : update_vif_enables23

// UVM run_phase
task uart_env23::run_phase(uvm_phase phase);
  fork 
    update_vif_enables23(); 
  join
endtask : run_phase
  
// Update the config when RGM23 updates23?
function void uart_env23::write(input uart_config23 cfg );
  this.cfg = cfg;
  update_config23(cfg);
endfunction : write

// Update Agent23 config when config updates23
function void uart_env23::update_config23(input uart_config23 cfg );
  Tx23.update_config23(cfg);
  Rx23.update_config23(cfg);   
endfunction : update_config23

`endif
