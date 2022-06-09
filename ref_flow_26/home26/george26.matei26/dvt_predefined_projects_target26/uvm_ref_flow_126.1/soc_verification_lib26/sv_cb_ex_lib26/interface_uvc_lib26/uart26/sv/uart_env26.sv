/*-------------------------------------------------------------------------
File26 name   : uart_env26.sv
Title26       : UART26 UVC26 env26 file 
Project26     :
Created26     :
Description26 : Creates26 and configures26 the UART26 UVC26
Notes26       :  
----------------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


`ifndef UART_ENV_SVH26
`define UART_ENV_SVH26

class uart_env26 extends uvm_env;

  // Virtual Interface26 variable
  virtual interface uart_if26 vif26;

  // Environment26 Configuration26 Paramters26
  uart_config26 cfg;         // UART26 configuration object
  bit checks_enable26 = 1;
  bit coverage_enable26 = 1;
   
  // Components of the environment26
  uart_tx_agent26 Tx26;
  uart_rx_agent26 Rx26;

  // Used26 to update the config when it is updated during simulation
  uvm_analysis_imp#(uart_config26, uart_env26) dut_cfg_port_in26;

  // This26 macro26 provide26 implementation of get_type_name() and create()
  `uvm_component_utils_begin(uart_env26)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable26, UVM_DEFAULT)
    `uvm_field_int(coverage_enable26, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor26 - required26 UVM syntax26
  function new( string name, uvm_component parent);
    super.new(name, parent);
    dut_cfg_port_in26 = new("dut_cfg_port_in26", this);
  endfunction

  // Additional26 class methods26
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables26();
  extern virtual function void write(uart_config26 cfg);
  extern virtual function void update_config26(uart_config26 cfg);

endclass : uart_env26

//UVM build_phase
function void uart_env26::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure26
  if ( cfg == null)
    if (!uvm_config_db#(uart_config26)::get(this, "", "cfg", cfg)) begin
      `uvm_info("NOCONFIG26", "No uart_config26, creating26...", UVM_MEDIUM)
      cfg = uart_config26::type_id::create("cfg", this);
      if (!cfg.randomize())
         `uvm_error("RNDFAIL26", "Could not randomize uart_config26 using default values")
      `uvm_info(get_type_name(), {"Printing26 cfg:\n", cfg.sprint()}, UVM_MEDIUM)
    end
  // Configure26 the sub-components26
  uvm_config_object::set(this, "Tx26*", "cfg", cfg);
  uvm_config_object::set(this, "Rx26*", "cfg", cfg);

  // Create26 sub-components26
  Tx26 = uart_tx_agent26::type_id::create("Tx26",this);
  Rx26 = uart_rx_agent26::type_id::create("Rx26",this);
endfunction : build_phase

//UVM connect_phase
function void uart_env26::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get26 the agent26's virtual interface if set via config
  if(!uvm_config_db#(virtual uart_if26)::get(this, "", "vif26", vif26))
    `uvm_error("NOVIF26",{"virtual interface must be set for: ",get_full_name(),".vif26"})
endfunction : connect_phase

// Function26 to assign the checks26 and coverage26 enable bits
task uart_env26::update_vif_enables26();
  // Make26 assignments26 at time 0 based on configuration
  vif26.has_checks26 <= checks_enable26;
  vif26.has_coverage <= coverage_enable26;
  forever begin
    @(checks_enable26 or coverage_enable26);
    vif26.has_checks26 <= checks_enable26;
    vif26.has_coverage <= coverage_enable26;
  end
endtask : update_vif_enables26

// UVM run_phase
task uart_env26::run_phase(uvm_phase phase);
  fork 
    update_vif_enables26(); 
  join
endtask : run_phase
  
// Update the config when RGM26 updates26?
function void uart_env26::write(input uart_config26 cfg );
  this.cfg = cfg;
  update_config26(cfg);
endfunction : write

// Update Agent26 config when config updates26
function void uart_env26::update_config26(input uart_config26 cfg );
  Tx26.update_config26(cfg);
  Rx26.update_config26(cfg);   
endfunction : update_config26

`endif
