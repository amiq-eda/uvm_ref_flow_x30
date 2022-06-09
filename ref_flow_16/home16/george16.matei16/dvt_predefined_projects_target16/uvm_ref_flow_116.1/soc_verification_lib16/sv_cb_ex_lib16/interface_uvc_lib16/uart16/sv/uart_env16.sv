/*-------------------------------------------------------------------------
File16 name   : uart_env16.sv
Title16       : UART16 UVC16 env16 file 
Project16     :
Created16     :
Description16 : Creates16 and configures16 the UART16 UVC16
Notes16       :  
----------------------------------------------------------------------*/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------


`ifndef UART_ENV_SVH16
`define UART_ENV_SVH16

class uart_env16 extends uvm_env;

  // Virtual Interface16 variable
  virtual interface uart_if16 vif16;

  // Environment16 Configuration16 Paramters16
  uart_config16 cfg;         // UART16 configuration object
  bit checks_enable16 = 1;
  bit coverage_enable16 = 1;
   
  // Components of the environment16
  uart_tx_agent16 Tx16;
  uart_rx_agent16 Rx16;

  // Used16 to update the config when it is updated during simulation
  uvm_analysis_imp#(uart_config16, uart_env16) dut_cfg_port_in16;

  // This16 macro16 provide16 implementation of get_type_name() and create()
  `uvm_component_utils_begin(uart_env16)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable16, UVM_DEFAULT)
    `uvm_field_int(coverage_enable16, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor16 - required16 UVM syntax16
  function new( string name, uvm_component parent);
    super.new(name, parent);
    dut_cfg_port_in16 = new("dut_cfg_port_in16", this);
  endfunction

  // Additional16 class methods16
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables16();
  extern virtual function void write(uart_config16 cfg);
  extern virtual function void update_config16(uart_config16 cfg);

endclass : uart_env16

//UVM build_phase
function void uart_env16::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure16
  if ( cfg == null)
    if (!uvm_config_db#(uart_config16)::get(this, "", "cfg", cfg)) begin
      `uvm_info("NOCONFIG16", "No uart_config16, creating16...", UVM_MEDIUM)
      cfg = uart_config16::type_id::create("cfg", this);
      if (!cfg.randomize())
         `uvm_error("RNDFAIL16", "Could not randomize uart_config16 using default values")
      `uvm_info(get_type_name(), {"Printing16 cfg:\n", cfg.sprint()}, UVM_MEDIUM)
    end
  // Configure16 the sub-components16
  uvm_config_object::set(this, "Tx16*", "cfg", cfg);
  uvm_config_object::set(this, "Rx16*", "cfg", cfg);

  // Create16 sub-components16
  Tx16 = uart_tx_agent16::type_id::create("Tx16",this);
  Rx16 = uart_rx_agent16::type_id::create("Rx16",this);
endfunction : build_phase

//UVM connect_phase
function void uart_env16::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get16 the agent16's virtual interface if set via config
  if(!uvm_config_db#(virtual uart_if16)::get(this, "", "vif16", vif16))
    `uvm_error("NOVIF16",{"virtual interface must be set for: ",get_full_name(),".vif16"})
endfunction : connect_phase

// Function16 to assign the checks16 and coverage16 enable bits
task uart_env16::update_vif_enables16();
  // Make16 assignments16 at time 0 based on configuration
  vif16.has_checks16 <= checks_enable16;
  vif16.has_coverage <= coverage_enable16;
  forever begin
    @(checks_enable16 or coverage_enable16);
    vif16.has_checks16 <= checks_enable16;
    vif16.has_coverage <= coverage_enable16;
  end
endtask : update_vif_enables16

// UVM run_phase
task uart_env16::run_phase(uvm_phase phase);
  fork 
    update_vif_enables16(); 
  join
endtask : run_phase
  
// Update the config when RGM16 updates16?
function void uart_env16::write(input uart_config16 cfg );
  this.cfg = cfg;
  update_config16(cfg);
endfunction : write

// Update Agent16 config when config updates16
function void uart_env16::update_config16(input uart_config16 cfg );
  Tx16.update_config16(cfg);
  Rx16.update_config16(cfg);   
endfunction : update_config16

`endif
