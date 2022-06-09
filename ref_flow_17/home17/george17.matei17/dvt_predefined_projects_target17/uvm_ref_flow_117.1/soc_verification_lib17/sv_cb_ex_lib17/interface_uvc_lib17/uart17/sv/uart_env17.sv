/*-------------------------------------------------------------------------
File17 name   : uart_env17.sv
Title17       : UART17 UVC17 env17 file 
Project17     :
Created17     :
Description17 : Creates17 and configures17 the UART17 UVC17
Notes17       :  
----------------------------------------------------------------------*/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------


`ifndef UART_ENV_SVH17
`define UART_ENV_SVH17

class uart_env17 extends uvm_env;

  // Virtual Interface17 variable
  virtual interface uart_if17 vif17;

  // Environment17 Configuration17 Paramters17
  uart_config17 cfg;         // UART17 configuration object
  bit checks_enable17 = 1;
  bit coverage_enable17 = 1;
   
  // Components of the environment17
  uart_tx_agent17 Tx17;
  uart_rx_agent17 Rx17;

  // Used17 to update the config when it is updated during simulation
  uvm_analysis_imp#(uart_config17, uart_env17) dut_cfg_port_in17;

  // This17 macro17 provide17 implementation of get_type_name() and create()
  `uvm_component_utils_begin(uart_env17)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable17, UVM_DEFAULT)
    `uvm_field_int(coverage_enable17, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor17 - required17 UVM syntax17
  function new( string name, uvm_component parent);
    super.new(name, parent);
    dut_cfg_port_in17 = new("dut_cfg_port_in17", this);
  endfunction

  // Additional17 class methods17
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables17();
  extern virtual function void write(uart_config17 cfg);
  extern virtual function void update_config17(uart_config17 cfg);

endclass : uart_env17

//UVM build_phase
function void uart_env17::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure17
  if ( cfg == null)
    if (!uvm_config_db#(uart_config17)::get(this, "", "cfg", cfg)) begin
      `uvm_info("NOCONFIG17", "No uart_config17, creating17...", UVM_MEDIUM)
      cfg = uart_config17::type_id::create("cfg", this);
      if (!cfg.randomize())
         `uvm_error("RNDFAIL17", "Could not randomize uart_config17 using default values")
      `uvm_info(get_type_name(), {"Printing17 cfg:\n", cfg.sprint()}, UVM_MEDIUM)
    end
  // Configure17 the sub-components17
  uvm_config_object::set(this, "Tx17*", "cfg", cfg);
  uvm_config_object::set(this, "Rx17*", "cfg", cfg);

  // Create17 sub-components17
  Tx17 = uart_tx_agent17::type_id::create("Tx17",this);
  Rx17 = uart_rx_agent17::type_id::create("Rx17",this);
endfunction : build_phase

//UVM connect_phase
function void uart_env17::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get17 the agent17's virtual interface if set via config
  if(!uvm_config_db#(virtual uart_if17)::get(this, "", "vif17", vif17))
    `uvm_error("NOVIF17",{"virtual interface must be set for: ",get_full_name(),".vif17"})
endfunction : connect_phase

// Function17 to assign the checks17 and coverage17 enable bits
task uart_env17::update_vif_enables17();
  // Make17 assignments17 at time 0 based on configuration
  vif17.has_checks17 <= checks_enable17;
  vif17.has_coverage <= coverage_enable17;
  forever begin
    @(checks_enable17 or coverage_enable17);
    vif17.has_checks17 <= checks_enable17;
    vif17.has_coverage <= coverage_enable17;
  end
endtask : update_vif_enables17

// UVM run_phase
task uart_env17::run_phase(uvm_phase phase);
  fork 
    update_vif_enables17(); 
  join
endtask : run_phase
  
// Update the config when RGM17 updates17?
function void uart_env17::write(input uart_config17 cfg );
  this.cfg = cfg;
  update_config17(cfg);
endfunction : write

// Update Agent17 config when config updates17
function void uart_env17::update_config17(input uart_config17 cfg );
  Tx17.update_config17(cfg);
  Rx17.update_config17(cfg);   
endfunction : update_config17

`endif
