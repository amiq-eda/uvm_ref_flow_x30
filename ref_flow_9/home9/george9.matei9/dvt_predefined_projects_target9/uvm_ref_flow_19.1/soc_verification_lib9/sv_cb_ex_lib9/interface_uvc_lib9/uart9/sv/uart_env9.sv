/*-------------------------------------------------------------------------
File9 name   : uart_env9.sv
Title9       : UART9 UVC9 env9 file 
Project9     :
Created9     :
Description9 : Creates9 and configures9 the UART9 UVC9
Notes9       :  
----------------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------


`ifndef UART_ENV_SVH9
`define UART_ENV_SVH9

class uart_env9 extends uvm_env;

  // Virtual Interface9 variable
  virtual interface uart_if9 vif9;

  // Environment9 Configuration9 Paramters9
  uart_config9 cfg;         // UART9 configuration object
  bit checks_enable9 = 1;
  bit coverage_enable9 = 1;
   
  // Components of the environment9
  uart_tx_agent9 Tx9;
  uart_rx_agent9 Rx9;

  // Used9 to update the config when it is updated during simulation
  uvm_analysis_imp#(uart_config9, uart_env9) dut_cfg_port_in9;

  // This9 macro9 provide9 implementation of get_type_name() and create()
  `uvm_component_utils_begin(uart_env9)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable9, UVM_DEFAULT)
    `uvm_field_int(coverage_enable9, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor9 - required9 UVM syntax9
  function new( string name, uvm_component parent);
    super.new(name, parent);
    dut_cfg_port_in9 = new("dut_cfg_port_in9", this);
  endfunction

  // Additional9 class methods9
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables9();
  extern virtual function void write(uart_config9 cfg);
  extern virtual function void update_config9(uart_config9 cfg);

endclass : uart_env9

//UVM build_phase
function void uart_env9::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure9
  if ( cfg == null)
    if (!uvm_config_db#(uart_config9)::get(this, "", "cfg", cfg)) begin
      `uvm_info("NOCONFIG9", "No uart_config9, creating9...", UVM_MEDIUM)
      cfg = uart_config9::type_id::create("cfg", this);
      if (!cfg.randomize())
         `uvm_error("RNDFAIL9", "Could not randomize uart_config9 using default values")
      `uvm_info(get_type_name(), {"Printing9 cfg:\n", cfg.sprint()}, UVM_MEDIUM)
    end
  // Configure9 the sub-components9
  uvm_config_object::set(this, "Tx9*", "cfg", cfg);
  uvm_config_object::set(this, "Rx9*", "cfg", cfg);

  // Create9 sub-components9
  Tx9 = uart_tx_agent9::type_id::create("Tx9",this);
  Rx9 = uart_rx_agent9::type_id::create("Rx9",this);
endfunction : build_phase

//UVM connect_phase
function void uart_env9::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get9 the agent9's virtual interface if set via config
  if(!uvm_config_db#(virtual uart_if9)::get(this, "", "vif9", vif9))
    `uvm_error("NOVIF9",{"virtual interface must be set for: ",get_full_name(),".vif9"})
endfunction : connect_phase

// Function9 to assign the checks9 and coverage9 enable bits
task uart_env9::update_vif_enables9();
  // Make9 assignments9 at time 0 based on configuration
  vif9.has_checks9 <= checks_enable9;
  vif9.has_coverage <= coverage_enable9;
  forever begin
    @(checks_enable9 or coverage_enable9);
    vif9.has_checks9 <= checks_enable9;
    vif9.has_coverage <= coverage_enable9;
  end
endtask : update_vif_enables9

// UVM run_phase
task uart_env9::run_phase(uvm_phase phase);
  fork 
    update_vif_enables9(); 
  join
endtask : run_phase
  
// Update the config when RGM9 updates9?
function void uart_env9::write(input uart_config9 cfg );
  this.cfg = cfg;
  update_config9(cfg);
endfunction : write

// Update Agent9 config when config updates9
function void uart_env9::update_config9(input uart_config9 cfg );
  Tx9.update_config9(cfg);
  Rx9.update_config9(cfg);   
endfunction : update_config9

`endif
