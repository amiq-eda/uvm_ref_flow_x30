/*-------------------------------------------------------------------------
File7 name   : uart_env7.sv
Title7       : UART7 UVC7 env7 file 
Project7     :
Created7     :
Description7 : Creates7 and configures7 the UART7 UVC7
Notes7       :  
----------------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------


`ifndef UART_ENV_SVH7
`define UART_ENV_SVH7

class uart_env7 extends uvm_env;

  // Virtual Interface7 variable
  virtual interface uart_if7 vif7;

  // Environment7 Configuration7 Paramters7
  uart_config7 cfg;         // UART7 configuration object
  bit checks_enable7 = 1;
  bit coverage_enable7 = 1;
   
  // Components of the environment7
  uart_tx_agent7 Tx7;
  uart_rx_agent7 Rx7;

  // Used7 to update the config when it is updated during simulation
  uvm_analysis_imp#(uart_config7, uart_env7) dut_cfg_port_in7;

  // This7 macro7 provide7 implementation of get_type_name() and create()
  `uvm_component_utils_begin(uart_env7)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable7, UVM_DEFAULT)
    `uvm_field_int(coverage_enable7, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor7 - required7 UVM syntax7
  function new( string name, uvm_component parent);
    super.new(name, parent);
    dut_cfg_port_in7 = new("dut_cfg_port_in7", this);
  endfunction

  // Additional7 class methods7
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables7();
  extern virtual function void write(uart_config7 cfg);
  extern virtual function void update_config7(uart_config7 cfg);

endclass : uart_env7

//UVM build_phase
function void uart_env7::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure7
  if ( cfg == null)
    if (!uvm_config_db#(uart_config7)::get(this, "", "cfg", cfg)) begin
      `uvm_info("NOCONFIG7", "No uart_config7, creating7...", UVM_MEDIUM)
      cfg = uart_config7::type_id::create("cfg", this);
      if (!cfg.randomize())
         `uvm_error("RNDFAIL7", "Could not randomize uart_config7 using default values")
      `uvm_info(get_type_name(), {"Printing7 cfg:\n", cfg.sprint()}, UVM_MEDIUM)
    end
  // Configure7 the sub-components7
  uvm_config_object::set(this, "Tx7*", "cfg", cfg);
  uvm_config_object::set(this, "Rx7*", "cfg", cfg);

  // Create7 sub-components7
  Tx7 = uart_tx_agent7::type_id::create("Tx7",this);
  Rx7 = uart_rx_agent7::type_id::create("Rx7",this);
endfunction : build_phase

//UVM connect_phase
function void uart_env7::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get7 the agent7's virtual interface if set via config
  if(!uvm_config_db#(virtual uart_if7)::get(this, "", "vif7", vif7))
    `uvm_error("NOVIF7",{"virtual interface must be set for: ",get_full_name(),".vif7"})
endfunction : connect_phase

// Function7 to assign the checks7 and coverage7 enable bits
task uart_env7::update_vif_enables7();
  // Make7 assignments7 at time 0 based on configuration
  vif7.has_checks7 <= checks_enable7;
  vif7.has_coverage <= coverage_enable7;
  forever begin
    @(checks_enable7 or coverage_enable7);
    vif7.has_checks7 <= checks_enable7;
    vif7.has_coverage <= coverage_enable7;
  end
endtask : update_vif_enables7

// UVM run_phase
task uart_env7::run_phase(uvm_phase phase);
  fork 
    update_vif_enables7(); 
  join
endtask : run_phase
  
// Update the config when RGM7 updates7?
function void uart_env7::write(input uart_config7 cfg );
  this.cfg = cfg;
  update_config7(cfg);
endfunction : write

// Update Agent7 config when config updates7
function void uart_env7::update_config7(input uart_config7 cfg );
  Tx7.update_config7(cfg);
  Rx7.update_config7(cfg);   
endfunction : update_config7

`endif
