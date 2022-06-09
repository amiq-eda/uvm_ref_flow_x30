/*-------------------------------------------------------------------------
File30 name   : uart_env30.sv
Title30       : UART30 UVC30 env30 file 
Project30     :
Created30     :
Description30 : Creates30 and configures30 the UART30 UVC30
Notes30       :  
----------------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


`ifndef UART_ENV_SVH30
`define UART_ENV_SVH30

class uart_env30 extends uvm_env;

  // Virtual Interface30 variable
  virtual interface uart_if30 vif30;

  // Environment30 Configuration30 Paramters30
  uart_config30 cfg;         // UART30 configuration object
  bit checks_enable30 = 1;
  bit coverage_enable30 = 1;
   
  // Components of the environment30
  uart_tx_agent30 Tx30;
  uart_rx_agent30 Rx30;

  // Used30 to update the config when it is updated during simulation
  uvm_analysis_imp#(uart_config30, uart_env30) dut_cfg_port_in30;

  // This30 macro30 provide30 implementation of get_type_name() and create()
  `uvm_component_utils_begin(uart_env30)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable30, UVM_DEFAULT)
    `uvm_field_int(coverage_enable30, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor30 - required30 UVM syntax30
  function new( string name, uvm_component parent);
    super.new(name, parent);
    dut_cfg_port_in30 = new("dut_cfg_port_in30", this);
  endfunction

  // Additional30 class methods30
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables30();
  extern virtual function void write(uart_config30 cfg);
  extern virtual function void update_config30(uart_config30 cfg);

endclass : uart_env30

//UVM build_phase
function void uart_env30::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure30
  if ( cfg == null)
    if (!uvm_config_db#(uart_config30)::get(this, "", "cfg", cfg)) begin
      `uvm_info("NOCONFIG30", "No uart_config30, creating30...", UVM_MEDIUM)
      cfg = uart_config30::type_id::create("cfg", this);
      if (!cfg.randomize())
         `uvm_error("RNDFAIL30", "Could not randomize uart_config30 using default values")
      `uvm_info(get_type_name(), {"Printing30 cfg:\n", cfg.sprint()}, UVM_MEDIUM)
    end
  // Configure30 the sub-components30
  uvm_config_object::set(this, "Tx30*", "cfg", cfg);
  uvm_config_object::set(this, "Rx30*", "cfg", cfg);

  // Create30 sub-components30
  Tx30 = uart_tx_agent30::type_id::create("Tx30",this);
  Rx30 = uart_rx_agent30::type_id::create("Rx30",this);
endfunction : build_phase

//UVM connect_phase
function void uart_env30::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get30 the agent30's virtual interface if set via config
  if(!uvm_config_db#(virtual uart_if30)::get(this, "", "vif30", vif30))
    `uvm_error("NOVIF30",{"virtual interface must be set for: ",get_full_name(),".vif30"})
endfunction : connect_phase

// Function30 to assign the checks30 and coverage30 enable bits
task uart_env30::update_vif_enables30();
  // Make30 assignments30 at time 0 based on configuration
  vif30.has_checks30 <= checks_enable30;
  vif30.has_coverage <= coverage_enable30;
  forever begin
    @(checks_enable30 or coverage_enable30);
    vif30.has_checks30 <= checks_enable30;
    vif30.has_coverage <= coverage_enable30;
  end
endtask : update_vif_enables30

// UVM run_phase
task uart_env30::run_phase(uvm_phase phase);
  fork 
    update_vif_enables30(); 
  join
endtask : run_phase
  
// Update the config when RGM30 updates30?
function void uart_env30::write(input uart_config30 cfg );
  this.cfg = cfg;
  update_config30(cfg);
endfunction : write

// Update Agent30 config when config updates30
function void uart_env30::update_config30(input uart_config30 cfg );
  Tx30.update_config30(cfg);
  Rx30.update_config30(cfg);   
endfunction : update_config30

`endif
