/*-------------------------------------------------------------------------
File15 name   : uart_env15.sv
Title15       : UART15 UVC15 env15 file 
Project15     :
Created15     :
Description15 : Creates15 and configures15 the UART15 UVC15
Notes15       :  
----------------------------------------------------------------------*/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------


`ifndef UART_ENV_SVH15
`define UART_ENV_SVH15

class uart_env15 extends uvm_env;

  // Virtual Interface15 variable
  virtual interface uart_if15 vif15;

  // Environment15 Configuration15 Paramters15
  uart_config15 cfg;         // UART15 configuration object
  bit checks_enable15 = 1;
  bit coverage_enable15 = 1;
   
  // Components of the environment15
  uart_tx_agent15 Tx15;
  uart_rx_agent15 Rx15;

  // Used15 to update the config when it is updated during simulation
  uvm_analysis_imp#(uart_config15, uart_env15) dut_cfg_port_in15;

  // This15 macro15 provide15 implementation of get_type_name() and create()
  `uvm_component_utils_begin(uart_env15)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable15, UVM_DEFAULT)
    `uvm_field_int(coverage_enable15, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor15 - required15 UVM syntax15
  function new( string name, uvm_component parent);
    super.new(name, parent);
    dut_cfg_port_in15 = new("dut_cfg_port_in15", this);
  endfunction

  // Additional15 class methods15
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables15();
  extern virtual function void write(uart_config15 cfg);
  extern virtual function void update_config15(uart_config15 cfg);

endclass : uart_env15

//UVM build_phase
function void uart_env15::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure15
  if ( cfg == null)
    if (!uvm_config_db#(uart_config15)::get(this, "", "cfg", cfg)) begin
      `uvm_info("NOCONFIG15", "No uart_config15, creating15...", UVM_MEDIUM)
      cfg = uart_config15::type_id::create("cfg", this);
      if (!cfg.randomize())
         `uvm_error("RNDFAIL15", "Could not randomize uart_config15 using default values")
      `uvm_info(get_type_name(), {"Printing15 cfg:\n", cfg.sprint()}, UVM_MEDIUM)
    end
  // Configure15 the sub-components15
  uvm_config_object::set(this, "Tx15*", "cfg", cfg);
  uvm_config_object::set(this, "Rx15*", "cfg", cfg);

  // Create15 sub-components15
  Tx15 = uart_tx_agent15::type_id::create("Tx15",this);
  Rx15 = uart_rx_agent15::type_id::create("Rx15",this);
endfunction : build_phase

//UVM connect_phase
function void uart_env15::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get15 the agent15's virtual interface if set via config
  if(!uvm_config_db#(virtual uart_if15)::get(this, "", "vif15", vif15))
    `uvm_error("NOVIF15",{"virtual interface must be set for: ",get_full_name(),".vif15"})
endfunction : connect_phase

// Function15 to assign the checks15 and coverage15 enable bits
task uart_env15::update_vif_enables15();
  // Make15 assignments15 at time 0 based on configuration
  vif15.has_checks15 <= checks_enable15;
  vif15.has_coverage <= coverage_enable15;
  forever begin
    @(checks_enable15 or coverage_enable15);
    vif15.has_checks15 <= checks_enable15;
    vif15.has_coverage <= coverage_enable15;
  end
endtask : update_vif_enables15

// UVM run_phase
task uart_env15::run_phase(uvm_phase phase);
  fork 
    update_vif_enables15(); 
  join
endtask : run_phase
  
// Update the config when RGM15 updates15?
function void uart_env15::write(input uart_config15 cfg );
  this.cfg = cfg;
  update_config15(cfg);
endfunction : write

// Update Agent15 config when config updates15
function void uart_env15::update_config15(input uart_config15 cfg );
  Tx15.update_config15(cfg);
  Rx15.update_config15(cfg);   
endfunction : update_config15

`endif
