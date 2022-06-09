/*-------------------------------------------------------------------------
File10 name   : uart_env10.sv
Title10       : UART10 UVC10 env10 file 
Project10     :
Created10     :
Description10 : Creates10 and configures10 the UART10 UVC10
Notes10       :  
----------------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------


`ifndef UART_ENV_SVH10
`define UART_ENV_SVH10

class uart_env10 extends uvm_env;

  // Virtual Interface10 variable
  virtual interface uart_if10 vif10;

  // Environment10 Configuration10 Paramters10
  uart_config10 cfg;         // UART10 configuration object
  bit checks_enable10 = 1;
  bit coverage_enable10 = 1;
   
  // Components of the environment10
  uart_tx_agent10 Tx10;
  uart_rx_agent10 Rx10;

  // Used10 to update the config when it is updated during simulation
  uvm_analysis_imp#(uart_config10, uart_env10) dut_cfg_port_in10;

  // This10 macro10 provide10 implementation of get_type_name() and create()
  `uvm_component_utils_begin(uart_env10)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable10, UVM_DEFAULT)
    `uvm_field_int(coverage_enable10, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor10 - required10 UVM syntax10
  function new( string name, uvm_component parent);
    super.new(name, parent);
    dut_cfg_port_in10 = new("dut_cfg_port_in10", this);
  endfunction

  // Additional10 class methods10
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables10();
  extern virtual function void write(uart_config10 cfg);
  extern virtual function void update_config10(uart_config10 cfg);

endclass : uart_env10

//UVM build_phase
function void uart_env10::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure10
  if ( cfg == null)
    if (!uvm_config_db#(uart_config10)::get(this, "", "cfg", cfg)) begin
      `uvm_info("NOCONFIG10", "No uart_config10, creating10...", UVM_MEDIUM)
      cfg = uart_config10::type_id::create("cfg", this);
      if (!cfg.randomize())
         `uvm_error("RNDFAIL10", "Could not randomize uart_config10 using default values")
      `uvm_info(get_type_name(), {"Printing10 cfg:\n", cfg.sprint()}, UVM_MEDIUM)
    end
  // Configure10 the sub-components10
  uvm_config_object::set(this, "Tx10*", "cfg", cfg);
  uvm_config_object::set(this, "Rx10*", "cfg", cfg);

  // Create10 sub-components10
  Tx10 = uart_tx_agent10::type_id::create("Tx10",this);
  Rx10 = uart_rx_agent10::type_id::create("Rx10",this);
endfunction : build_phase

//UVM connect_phase
function void uart_env10::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get10 the agent10's virtual interface if set via config
  if(!uvm_config_db#(virtual uart_if10)::get(this, "", "vif10", vif10))
    `uvm_error("NOVIF10",{"virtual interface must be set for: ",get_full_name(),".vif10"})
endfunction : connect_phase

// Function10 to assign the checks10 and coverage10 enable bits
task uart_env10::update_vif_enables10();
  // Make10 assignments10 at time 0 based on configuration
  vif10.has_checks10 <= checks_enable10;
  vif10.has_coverage <= coverage_enable10;
  forever begin
    @(checks_enable10 or coverage_enable10);
    vif10.has_checks10 <= checks_enable10;
    vif10.has_coverage <= coverage_enable10;
  end
endtask : update_vif_enables10

// UVM run_phase
task uart_env10::run_phase(uvm_phase phase);
  fork 
    update_vif_enables10(); 
  join
endtask : run_phase
  
// Update the config when RGM10 updates10?
function void uart_env10::write(input uart_config10 cfg );
  this.cfg = cfg;
  update_config10(cfg);
endfunction : write

// Update Agent10 config when config updates10
function void uart_env10::update_config10(input uart_config10 cfg );
  Tx10.update_config10(cfg);
  Rx10.update_config10(cfg);   
endfunction : update_config10

`endif
