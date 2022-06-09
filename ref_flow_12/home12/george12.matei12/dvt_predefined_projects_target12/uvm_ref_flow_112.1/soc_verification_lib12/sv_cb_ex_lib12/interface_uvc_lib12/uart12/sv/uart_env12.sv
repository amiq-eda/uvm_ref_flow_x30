/*-------------------------------------------------------------------------
File12 name   : uart_env12.sv
Title12       : UART12 UVC12 env12 file 
Project12     :
Created12     :
Description12 : Creates12 and configures12 the UART12 UVC12
Notes12       :  
----------------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------


`ifndef UART_ENV_SVH12
`define UART_ENV_SVH12

class uart_env12 extends uvm_env;

  // Virtual Interface12 variable
  virtual interface uart_if12 vif12;

  // Environment12 Configuration12 Paramters12
  uart_config12 cfg;         // UART12 configuration object
  bit checks_enable12 = 1;
  bit coverage_enable12 = 1;
   
  // Components of the environment12
  uart_tx_agent12 Tx12;
  uart_rx_agent12 Rx12;

  // Used12 to update the config when it is updated during simulation
  uvm_analysis_imp#(uart_config12, uart_env12) dut_cfg_port_in12;

  // This12 macro12 provide12 implementation of get_type_name() and create()
  `uvm_component_utils_begin(uart_env12)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable12, UVM_DEFAULT)
    `uvm_field_int(coverage_enable12, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor12 - required12 UVM syntax12
  function new( string name, uvm_component parent);
    super.new(name, parent);
    dut_cfg_port_in12 = new("dut_cfg_port_in12", this);
  endfunction

  // Additional12 class methods12
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables12();
  extern virtual function void write(uart_config12 cfg);
  extern virtual function void update_config12(uart_config12 cfg);

endclass : uart_env12

//UVM build_phase
function void uart_env12::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure12
  if ( cfg == null)
    if (!uvm_config_db#(uart_config12)::get(this, "", "cfg", cfg)) begin
      `uvm_info("NOCONFIG12", "No uart_config12, creating12...", UVM_MEDIUM)
      cfg = uart_config12::type_id::create("cfg", this);
      if (!cfg.randomize())
         `uvm_error("RNDFAIL12", "Could not randomize uart_config12 using default values")
      `uvm_info(get_type_name(), {"Printing12 cfg:\n", cfg.sprint()}, UVM_MEDIUM)
    end
  // Configure12 the sub-components12
  uvm_config_object::set(this, "Tx12*", "cfg", cfg);
  uvm_config_object::set(this, "Rx12*", "cfg", cfg);

  // Create12 sub-components12
  Tx12 = uart_tx_agent12::type_id::create("Tx12",this);
  Rx12 = uart_rx_agent12::type_id::create("Rx12",this);
endfunction : build_phase

//UVM connect_phase
function void uart_env12::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get12 the agent12's virtual interface if set via config
  if(!uvm_config_db#(virtual uart_if12)::get(this, "", "vif12", vif12))
    `uvm_error("NOVIF12",{"virtual interface must be set for: ",get_full_name(),".vif12"})
endfunction : connect_phase

// Function12 to assign the checks12 and coverage12 enable bits
task uart_env12::update_vif_enables12();
  // Make12 assignments12 at time 0 based on configuration
  vif12.has_checks12 <= checks_enable12;
  vif12.has_coverage <= coverage_enable12;
  forever begin
    @(checks_enable12 or coverage_enable12);
    vif12.has_checks12 <= checks_enable12;
    vif12.has_coverage <= coverage_enable12;
  end
endtask : update_vif_enables12

// UVM run_phase
task uart_env12::run_phase(uvm_phase phase);
  fork 
    update_vif_enables12(); 
  join
endtask : run_phase
  
// Update the config when RGM12 updates12?
function void uart_env12::write(input uart_config12 cfg );
  this.cfg = cfg;
  update_config12(cfg);
endfunction : write

// Update Agent12 config when config updates12
function void uart_env12::update_config12(input uart_config12 cfg );
  Tx12.update_config12(cfg);
  Rx12.update_config12(cfg);   
endfunction : update_config12

`endif
