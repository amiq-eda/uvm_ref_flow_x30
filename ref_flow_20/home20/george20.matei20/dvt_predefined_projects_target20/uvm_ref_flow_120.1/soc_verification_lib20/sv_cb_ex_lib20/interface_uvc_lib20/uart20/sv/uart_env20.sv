/*-------------------------------------------------------------------------
File20 name   : uart_env20.sv
Title20       : UART20 UVC20 env20 file 
Project20     :
Created20     :
Description20 : Creates20 and configures20 the UART20 UVC20
Notes20       :  
----------------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------


`ifndef UART_ENV_SVH20
`define UART_ENV_SVH20

class uart_env20 extends uvm_env;

  // Virtual Interface20 variable
  virtual interface uart_if20 vif20;

  // Environment20 Configuration20 Paramters20
  uart_config20 cfg;         // UART20 configuration object
  bit checks_enable20 = 1;
  bit coverage_enable20 = 1;
   
  // Components of the environment20
  uart_tx_agent20 Tx20;
  uart_rx_agent20 Rx20;

  // Used20 to update the config when it is updated during simulation
  uvm_analysis_imp#(uart_config20, uart_env20) dut_cfg_port_in20;

  // This20 macro20 provide20 implementation of get_type_name() and create()
  `uvm_component_utils_begin(uart_env20)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable20, UVM_DEFAULT)
    `uvm_field_int(coverage_enable20, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor20 - required20 UVM syntax20
  function new( string name, uvm_component parent);
    super.new(name, parent);
    dut_cfg_port_in20 = new("dut_cfg_port_in20", this);
  endfunction

  // Additional20 class methods20
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables20();
  extern virtual function void write(uart_config20 cfg);
  extern virtual function void update_config20(uart_config20 cfg);

endclass : uart_env20

//UVM build_phase
function void uart_env20::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure20
  if ( cfg == null)
    if (!uvm_config_db#(uart_config20)::get(this, "", "cfg", cfg)) begin
      `uvm_info("NOCONFIG20", "No uart_config20, creating20...", UVM_MEDIUM)
      cfg = uart_config20::type_id::create("cfg", this);
      if (!cfg.randomize())
         `uvm_error("RNDFAIL20", "Could not randomize uart_config20 using default values")
      `uvm_info(get_type_name(), {"Printing20 cfg:\n", cfg.sprint()}, UVM_MEDIUM)
    end
  // Configure20 the sub-components20
  uvm_config_object::set(this, "Tx20*", "cfg", cfg);
  uvm_config_object::set(this, "Rx20*", "cfg", cfg);

  // Create20 sub-components20
  Tx20 = uart_tx_agent20::type_id::create("Tx20",this);
  Rx20 = uart_rx_agent20::type_id::create("Rx20",this);
endfunction : build_phase

//UVM connect_phase
function void uart_env20::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get20 the agent20's virtual interface if set via config
  if(!uvm_config_db#(virtual uart_if20)::get(this, "", "vif20", vif20))
    `uvm_error("NOVIF20",{"virtual interface must be set for: ",get_full_name(),".vif20"})
endfunction : connect_phase

// Function20 to assign the checks20 and coverage20 enable bits
task uart_env20::update_vif_enables20();
  // Make20 assignments20 at time 0 based on configuration
  vif20.has_checks20 <= checks_enable20;
  vif20.has_coverage <= coverage_enable20;
  forever begin
    @(checks_enable20 or coverage_enable20);
    vif20.has_checks20 <= checks_enable20;
    vif20.has_coverage <= coverage_enable20;
  end
endtask : update_vif_enables20

// UVM run_phase
task uart_env20::run_phase(uvm_phase phase);
  fork 
    update_vif_enables20(); 
  join
endtask : run_phase
  
// Update the config when RGM20 updates20?
function void uart_env20::write(input uart_config20 cfg );
  this.cfg = cfg;
  update_config20(cfg);
endfunction : write

// Update Agent20 config when config updates20
function void uart_env20::update_config20(input uart_config20 cfg );
  Tx20.update_config20(cfg);
  Rx20.update_config20(cfg);   
endfunction : update_config20

`endif
