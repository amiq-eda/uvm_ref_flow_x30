/*-------------------------------------------------------------------------
File25 name   : uart_env25.sv
Title25       : UART25 UVC25 env25 file 
Project25     :
Created25     :
Description25 : Creates25 and configures25 the UART25 UVC25
Notes25       :  
----------------------------------------------------------------------*/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------


`ifndef UART_ENV_SVH25
`define UART_ENV_SVH25

class uart_env25 extends uvm_env;

  // Virtual Interface25 variable
  virtual interface uart_if25 vif25;

  // Environment25 Configuration25 Paramters25
  uart_config25 cfg;         // UART25 configuration object
  bit checks_enable25 = 1;
  bit coverage_enable25 = 1;
   
  // Components of the environment25
  uart_tx_agent25 Tx25;
  uart_rx_agent25 Rx25;

  // Used25 to update the config when it is updated during simulation
  uvm_analysis_imp#(uart_config25, uart_env25) dut_cfg_port_in25;

  // This25 macro25 provide25 implementation of get_type_name() and create()
  `uvm_component_utils_begin(uart_env25)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable25, UVM_DEFAULT)
    `uvm_field_int(coverage_enable25, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor25 - required25 UVM syntax25
  function new( string name, uvm_component parent);
    super.new(name, parent);
    dut_cfg_port_in25 = new("dut_cfg_port_in25", this);
  endfunction

  // Additional25 class methods25
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables25();
  extern virtual function void write(uart_config25 cfg);
  extern virtual function void update_config25(uart_config25 cfg);

endclass : uart_env25

//UVM build_phase
function void uart_env25::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure25
  if ( cfg == null)
    if (!uvm_config_db#(uart_config25)::get(this, "", "cfg", cfg)) begin
      `uvm_info("NOCONFIG25", "No uart_config25, creating25...", UVM_MEDIUM)
      cfg = uart_config25::type_id::create("cfg", this);
      if (!cfg.randomize())
         `uvm_error("RNDFAIL25", "Could not randomize uart_config25 using default values")
      `uvm_info(get_type_name(), {"Printing25 cfg:\n", cfg.sprint()}, UVM_MEDIUM)
    end
  // Configure25 the sub-components25
  uvm_config_object::set(this, "Tx25*", "cfg", cfg);
  uvm_config_object::set(this, "Rx25*", "cfg", cfg);

  // Create25 sub-components25
  Tx25 = uart_tx_agent25::type_id::create("Tx25",this);
  Rx25 = uart_rx_agent25::type_id::create("Rx25",this);
endfunction : build_phase

//UVM connect_phase
function void uart_env25::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get25 the agent25's virtual interface if set via config
  if(!uvm_config_db#(virtual uart_if25)::get(this, "", "vif25", vif25))
    `uvm_error("NOVIF25",{"virtual interface must be set for: ",get_full_name(),".vif25"})
endfunction : connect_phase

// Function25 to assign the checks25 and coverage25 enable bits
task uart_env25::update_vif_enables25();
  // Make25 assignments25 at time 0 based on configuration
  vif25.has_checks25 <= checks_enable25;
  vif25.has_coverage <= coverage_enable25;
  forever begin
    @(checks_enable25 or coverage_enable25);
    vif25.has_checks25 <= checks_enable25;
    vif25.has_coverage <= coverage_enable25;
  end
endtask : update_vif_enables25

// UVM run_phase
task uart_env25::run_phase(uvm_phase phase);
  fork 
    update_vif_enables25(); 
  join
endtask : run_phase
  
// Update the config when RGM25 updates25?
function void uart_env25::write(input uart_config25 cfg );
  this.cfg = cfg;
  update_config25(cfg);
endfunction : write

// Update Agent25 config when config updates25
function void uart_env25::update_config25(input uart_config25 cfg );
  Tx25.update_config25(cfg);
  Rx25.update_config25(cfg);   
endfunction : update_config25

`endif
