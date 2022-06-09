/*-------------------------------------------------------------------------
File8 name   : uart_env8.sv
Title8       : UART8 UVC8 env8 file 
Project8     :
Created8     :
Description8 : Creates8 and configures8 the UART8 UVC8
Notes8       :  
----------------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------


`ifndef UART_ENV_SVH8
`define UART_ENV_SVH8

class uart_env8 extends uvm_env;

  // Virtual Interface8 variable
  virtual interface uart_if8 vif8;

  // Environment8 Configuration8 Paramters8
  uart_config8 cfg;         // UART8 configuration object
  bit checks_enable8 = 1;
  bit coverage_enable8 = 1;
   
  // Components of the environment8
  uart_tx_agent8 Tx8;
  uart_rx_agent8 Rx8;

  // Used8 to update the config when it is updated during simulation
  uvm_analysis_imp#(uart_config8, uart_env8) dut_cfg_port_in8;

  // This8 macro8 provide8 implementation of get_type_name() and create()
  `uvm_component_utils_begin(uart_env8)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable8, UVM_DEFAULT)
    `uvm_field_int(coverage_enable8, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor8 - required8 UVM syntax8
  function new( string name, uvm_component parent);
    super.new(name, parent);
    dut_cfg_port_in8 = new("dut_cfg_port_in8", this);
  endfunction

  // Additional8 class methods8
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables8();
  extern virtual function void write(uart_config8 cfg);
  extern virtual function void update_config8(uart_config8 cfg);

endclass : uart_env8

//UVM build_phase
function void uart_env8::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure8
  if ( cfg == null)
    if (!uvm_config_db#(uart_config8)::get(this, "", "cfg", cfg)) begin
      `uvm_info("NOCONFIG8", "No uart_config8, creating8...", UVM_MEDIUM)
      cfg = uart_config8::type_id::create("cfg", this);
      if (!cfg.randomize())
         `uvm_error("RNDFAIL8", "Could not randomize uart_config8 using default values")
      `uvm_info(get_type_name(), {"Printing8 cfg:\n", cfg.sprint()}, UVM_MEDIUM)
    end
  // Configure8 the sub-components8
  uvm_config_object::set(this, "Tx8*", "cfg", cfg);
  uvm_config_object::set(this, "Rx8*", "cfg", cfg);

  // Create8 sub-components8
  Tx8 = uart_tx_agent8::type_id::create("Tx8",this);
  Rx8 = uart_rx_agent8::type_id::create("Rx8",this);
endfunction : build_phase

//UVM connect_phase
function void uart_env8::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get8 the agent8's virtual interface if set via config
  if(!uvm_config_db#(virtual uart_if8)::get(this, "", "vif8", vif8))
    `uvm_error("NOVIF8",{"virtual interface must be set for: ",get_full_name(),".vif8"})
endfunction : connect_phase

// Function8 to assign the checks8 and coverage8 enable bits
task uart_env8::update_vif_enables8();
  // Make8 assignments8 at time 0 based on configuration
  vif8.has_checks8 <= checks_enable8;
  vif8.has_coverage <= coverage_enable8;
  forever begin
    @(checks_enable8 or coverage_enable8);
    vif8.has_checks8 <= checks_enable8;
    vif8.has_coverage <= coverage_enable8;
  end
endtask : update_vif_enables8

// UVM run_phase
task uart_env8::run_phase(uvm_phase phase);
  fork 
    update_vif_enables8(); 
  join
endtask : run_phase
  
// Update the config when RGM8 updates8?
function void uart_env8::write(input uart_config8 cfg );
  this.cfg = cfg;
  update_config8(cfg);
endfunction : write

// Update Agent8 config when config updates8
function void uart_env8::update_config8(input uart_config8 cfg );
  Tx8.update_config8(cfg);
  Rx8.update_config8(cfg);   
endfunction : update_config8

`endif
