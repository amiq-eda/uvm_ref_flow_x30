/*-------------------------------------------------------------------------
File24 name   : uart_env24.sv
Title24       : UART24 UVC24 env24 file 
Project24     :
Created24     :
Description24 : Creates24 and configures24 the UART24 UVC24
Notes24       :  
----------------------------------------------------------------------*/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------


`ifndef UART_ENV_SVH24
`define UART_ENV_SVH24

class uart_env24 extends uvm_env;

  // Virtual Interface24 variable
  virtual interface uart_if24 vif24;

  // Environment24 Configuration24 Paramters24
  uart_config24 cfg;         // UART24 configuration object
  bit checks_enable24 = 1;
  bit coverage_enable24 = 1;
   
  // Components of the environment24
  uart_tx_agent24 Tx24;
  uart_rx_agent24 Rx24;

  // Used24 to update the config when it is updated during simulation
  uvm_analysis_imp#(uart_config24, uart_env24) dut_cfg_port_in24;

  // This24 macro24 provide24 implementation of get_type_name() and create()
  `uvm_component_utils_begin(uart_env24)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable24, UVM_DEFAULT)
    `uvm_field_int(coverage_enable24, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor24 - required24 UVM syntax24
  function new( string name, uvm_component parent);
    super.new(name, parent);
    dut_cfg_port_in24 = new("dut_cfg_port_in24", this);
  endfunction

  // Additional24 class methods24
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables24();
  extern virtual function void write(uart_config24 cfg);
  extern virtual function void update_config24(uart_config24 cfg);

endclass : uart_env24

//UVM build_phase
function void uart_env24::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure24
  if ( cfg == null)
    if (!uvm_config_db#(uart_config24)::get(this, "", "cfg", cfg)) begin
      `uvm_info("NOCONFIG24", "No uart_config24, creating24...", UVM_MEDIUM)
      cfg = uart_config24::type_id::create("cfg", this);
      if (!cfg.randomize())
         `uvm_error("RNDFAIL24", "Could not randomize uart_config24 using default values")
      `uvm_info(get_type_name(), {"Printing24 cfg:\n", cfg.sprint()}, UVM_MEDIUM)
    end
  // Configure24 the sub-components24
  uvm_config_object::set(this, "Tx24*", "cfg", cfg);
  uvm_config_object::set(this, "Rx24*", "cfg", cfg);

  // Create24 sub-components24
  Tx24 = uart_tx_agent24::type_id::create("Tx24",this);
  Rx24 = uart_rx_agent24::type_id::create("Rx24",this);
endfunction : build_phase

//UVM connect_phase
function void uart_env24::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get24 the agent24's virtual interface if set via config
  if(!uvm_config_db#(virtual uart_if24)::get(this, "", "vif24", vif24))
    `uvm_error("NOVIF24",{"virtual interface must be set for: ",get_full_name(),".vif24"})
endfunction : connect_phase

// Function24 to assign the checks24 and coverage24 enable bits
task uart_env24::update_vif_enables24();
  // Make24 assignments24 at time 0 based on configuration
  vif24.has_checks24 <= checks_enable24;
  vif24.has_coverage <= coverage_enable24;
  forever begin
    @(checks_enable24 or coverage_enable24);
    vif24.has_checks24 <= checks_enable24;
    vif24.has_coverage <= coverage_enable24;
  end
endtask : update_vif_enables24

// UVM run_phase
task uart_env24::run_phase(uvm_phase phase);
  fork 
    update_vif_enables24(); 
  join
endtask : run_phase
  
// Update the config when RGM24 updates24?
function void uart_env24::write(input uart_config24 cfg );
  this.cfg = cfg;
  update_config24(cfg);
endfunction : write

// Update Agent24 config when config updates24
function void uart_env24::update_config24(input uart_config24 cfg );
  Tx24.update_config24(cfg);
  Rx24.update_config24(cfg);   
endfunction : update_config24

`endif
