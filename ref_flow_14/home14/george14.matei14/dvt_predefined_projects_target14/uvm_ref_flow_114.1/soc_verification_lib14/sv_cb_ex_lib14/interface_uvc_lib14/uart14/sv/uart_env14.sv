/*-------------------------------------------------------------------------
File14 name   : uart_env14.sv
Title14       : UART14 UVC14 env14 file 
Project14     :
Created14     :
Description14 : Creates14 and configures14 the UART14 UVC14
Notes14       :  
----------------------------------------------------------------------*/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------


`ifndef UART_ENV_SVH14
`define UART_ENV_SVH14

class uart_env14 extends uvm_env;

  // Virtual Interface14 variable
  virtual interface uart_if14 vif14;

  // Environment14 Configuration14 Paramters14
  uart_config14 cfg;         // UART14 configuration object
  bit checks_enable14 = 1;
  bit coverage_enable14 = 1;
   
  // Components of the environment14
  uart_tx_agent14 Tx14;
  uart_rx_agent14 Rx14;

  // Used14 to update the config when it is updated during simulation
  uvm_analysis_imp#(uart_config14, uart_env14) dut_cfg_port_in14;

  // This14 macro14 provide14 implementation of get_type_name() and create()
  `uvm_component_utils_begin(uart_env14)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable14, UVM_DEFAULT)
    `uvm_field_int(coverage_enable14, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor14 - required14 UVM syntax14
  function new( string name, uvm_component parent);
    super.new(name, parent);
    dut_cfg_port_in14 = new("dut_cfg_port_in14", this);
  endfunction

  // Additional14 class methods14
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables14();
  extern virtual function void write(uart_config14 cfg);
  extern virtual function void update_config14(uart_config14 cfg);

endclass : uart_env14

//UVM build_phase
function void uart_env14::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure14
  if ( cfg == null)
    if (!uvm_config_db#(uart_config14)::get(this, "", "cfg", cfg)) begin
      `uvm_info("NOCONFIG14", "No uart_config14, creating14...", UVM_MEDIUM)
      cfg = uart_config14::type_id::create("cfg", this);
      if (!cfg.randomize())
         `uvm_error("RNDFAIL14", "Could not randomize uart_config14 using default values")
      `uvm_info(get_type_name(), {"Printing14 cfg:\n", cfg.sprint()}, UVM_MEDIUM)
    end
  // Configure14 the sub-components14
  uvm_config_object::set(this, "Tx14*", "cfg", cfg);
  uvm_config_object::set(this, "Rx14*", "cfg", cfg);

  // Create14 sub-components14
  Tx14 = uart_tx_agent14::type_id::create("Tx14",this);
  Rx14 = uart_rx_agent14::type_id::create("Rx14",this);
endfunction : build_phase

//UVM connect_phase
function void uart_env14::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get14 the agent14's virtual interface if set via config
  if(!uvm_config_db#(virtual uart_if14)::get(this, "", "vif14", vif14))
    `uvm_error("NOVIF14",{"virtual interface must be set for: ",get_full_name(),".vif14"})
endfunction : connect_phase

// Function14 to assign the checks14 and coverage14 enable bits
task uart_env14::update_vif_enables14();
  // Make14 assignments14 at time 0 based on configuration
  vif14.has_checks14 <= checks_enable14;
  vif14.has_coverage <= coverage_enable14;
  forever begin
    @(checks_enable14 or coverage_enable14);
    vif14.has_checks14 <= checks_enable14;
    vif14.has_coverage <= coverage_enable14;
  end
endtask : update_vif_enables14

// UVM run_phase
task uart_env14::run_phase(uvm_phase phase);
  fork 
    update_vif_enables14(); 
  join
endtask : run_phase
  
// Update the config when RGM14 updates14?
function void uart_env14::write(input uart_config14 cfg );
  this.cfg = cfg;
  update_config14(cfg);
endfunction : write

// Update Agent14 config when config updates14
function void uart_env14::update_config14(input uart_config14 cfg );
  Tx14.update_config14(cfg);
  Rx14.update_config14(cfg);   
endfunction : update_config14

`endif
