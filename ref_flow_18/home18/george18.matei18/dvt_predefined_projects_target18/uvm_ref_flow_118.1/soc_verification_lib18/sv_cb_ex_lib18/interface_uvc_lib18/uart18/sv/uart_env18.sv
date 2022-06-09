/*-------------------------------------------------------------------------
File18 name   : uart_env18.sv
Title18       : UART18 UVC18 env18 file 
Project18     :
Created18     :
Description18 : Creates18 and configures18 the UART18 UVC18
Notes18       :  
----------------------------------------------------------------------*/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------


`ifndef UART_ENV_SVH18
`define UART_ENV_SVH18

class uart_env18 extends uvm_env;

  // Virtual Interface18 variable
  virtual interface uart_if18 vif18;

  // Environment18 Configuration18 Paramters18
  uart_config18 cfg;         // UART18 configuration object
  bit checks_enable18 = 1;
  bit coverage_enable18 = 1;
   
  // Components of the environment18
  uart_tx_agent18 Tx18;
  uart_rx_agent18 Rx18;

  // Used18 to update the config when it is updated during simulation
  uvm_analysis_imp#(uart_config18, uart_env18) dut_cfg_port_in18;

  // This18 macro18 provide18 implementation of get_type_name() and create()
  `uvm_component_utils_begin(uart_env18)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable18, UVM_DEFAULT)
    `uvm_field_int(coverage_enable18, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor18 - required18 UVM syntax18
  function new( string name, uvm_component parent);
    super.new(name, parent);
    dut_cfg_port_in18 = new("dut_cfg_port_in18", this);
  endfunction

  // Additional18 class methods18
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables18();
  extern virtual function void write(uart_config18 cfg);
  extern virtual function void update_config18(uart_config18 cfg);

endclass : uart_env18

//UVM build_phase
function void uart_env18::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure18
  if ( cfg == null)
    if (!uvm_config_db#(uart_config18)::get(this, "", "cfg", cfg)) begin
      `uvm_info("NOCONFIG18", "No uart_config18, creating18...", UVM_MEDIUM)
      cfg = uart_config18::type_id::create("cfg", this);
      if (!cfg.randomize())
         `uvm_error("RNDFAIL18", "Could not randomize uart_config18 using default values")
      `uvm_info(get_type_name(), {"Printing18 cfg:\n", cfg.sprint()}, UVM_MEDIUM)
    end
  // Configure18 the sub-components18
  uvm_config_object::set(this, "Tx18*", "cfg", cfg);
  uvm_config_object::set(this, "Rx18*", "cfg", cfg);

  // Create18 sub-components18
  Tx18 = uart_tx_agent18::type_id::create("Tx18",this);
  Rx18 = uart_rx_agent18::type_id::create("Rx18",this);
endfunction : build_phase

//UVM connect_phase
function void uart_env18::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get18 the agent18's virtual interface if set via config
  if(!uvm_config_db#(virtual uart_if18)::get(this, "", "vif18", vif18))
    `uvm_error("NOVIF18",{"virtual interface must be set for: ",get_full_name(),".vif18"})
endfunction : connect_phase

// Function18 to assign the checks18 and coverage18 enable bits
task uart_env18::update_vif_enables18();
  // Make18 assignments18 at time 0 based on configuration
  vif18.has_checks18 <= checks_enable18;
  vif18.has_coverage <= coverage_enable18;
  forever begin
    @(checks_enable18 or coverage_enable18);
    vif18.has_checks18 <= checks_enable18;
    vif18.has_coverage <= coverage_enable18;
  end
endtask : update_vif_enables18

// UVM run_phase
task uart_env18::run_phase(uvm_phase phase);
  fork 
    update_vif_enables18(); 
  join
endtask : run_phase
  
// Update the config when RGM18 updates18?
function void uart_env18::write(input uart_config18 cfg );
  this.cfg = cfg;
  update_config18(cfg);
endfunction : write

// Update Agent18 config when config updates18
function void uart_env18::update_config18(input uart_config18 cfg );
  Tx18.update_config18(cfg);
  Rx18.update_config18(cfg);   
endfunction : update_config18

`endif
