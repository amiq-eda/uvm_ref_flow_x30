/*-------------------------------------------------------------------------
File4 name   : uart_env4.sv
Title4       : UART4 UVC4 env4 file 
Project4     :
Created4     :
Description4 : Creates4 and configures4 the UART4 UVC4
Notes4       :  
----------------------------------------------------------------------*/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------


`ifndef UART_ENV_SVH4
`define UART_ENV_SVH4

class uart_env4 extends uvm_env;

  // Virtual Interface4 variable
  virtual interface uart_if4 vif4;

  // Environment4 Configuration4 Paramters4
  uart_config4 cfg;         // UART4 configuration object
  bit checks_enable4 = 1;
  bit coverage_enable4 = 1;
   
  // Components of the environment4
  uart_tx_agent4 Tx4;
  uart_rx_agent4 Rx4;

  // Used4 to update the config when it is updated during simulation
  uvm_analysis_imp#(uart_config4, uart_env4) dut_cfg_port_in4;

  // This4 macro4 provide4 implementation of get_type_name() and create()
  `uvm_component_utils_begin(uart_env4)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable4, UVM_DEFAULT)
    `uvm_field_int(coverage_enable4, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor4 - required4 UVM syntax4
  function new( string name, uvm_component parent);
    super.new(name, parent);
    dut_cfg_port_in4 = new("dut_cfg_port_in4", this);
  endfunction

  // Additional4 class methods4
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables4();
  extern virtual function void write(uart_config4 cfg);
  extern virtual function void update_config4(uart_config4 cfg);

endclass : uart_env4

//UVM build_phase
function void uart_env4::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure4
  if ( cfg == null)
    if (!uvm_config_db#(uart_config4)::get(this, "", "cfg", cfg)) begin
      `uvm_info("NOCONFIG4", "No uart_config4, creating4...", UVM_MEDIUM)
      cfg = uart_config4::type_id::create("cfg", this);
      if (!cfg.randomize())
         `uvm_error("RNDFAIL4", "Could not randomize uart_config4 using default values")
      `uvm_info(get_type_name(), {"Printing4 cfg:\n", cfg.sprint()}, UVM_MEDIUM)
    end
  // Configure4 the sub-components4
  uvm_config_object::set(this, "Tx4*", "cfg", cfg);
  uvm_config_object::set(this, "Rx4*", "cfg", cfg);

  // Create4 sub-components4
  Tx4 = uart_tx_agent4::type_id::create("Tx4",this);
  Rx4 = uart_rx_agent4::type_id::create("Rx4",this);
endfunction : build_phase

//UVM connect_phase
function void uart_env4::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get4 the agent4's virtual interface if set via config
  if(!uvm_config_db#(virtual uart_if4)::get(this, "", "vif4", vif4))
    `uvm_error("NOVIF4",{"virtual interface must be set for: ",get_full_name(),".vif4"})
endfunction : connect_phase

// Function4 to assign the checks4 and coverage4 enable bits
task uart_env4::update_vif_enables4();
  // Make4 assignments4 at time 0 based on configuration
  vif4.has_checks4 <= checks_enable4;
  vif4.has_coverage <= coverage_enable4;
  forever begin
    @(checks_enable4 or coverage_enable4);
    vif4.has_checks4 <= checks_enable4;
    vif4.has_coverage <= coverage_enable4;
  end
endtask : update_vif_enables4

// UVM run_phase
task uart_env4::run_phase(uvm_phase phase);
  fork 
    update_vif_enables4(); 
  join
endtask : run_phase
  
// Update the config when RGM4 updates4?
function void uart_env4::write(input uart_config4 cfg );
  this.cfg = cfg;
  update_config4(cfg);
endfunction : write

// Update Agent4 config when config updates4
function void uart_env4::update_config4(input uart_config4 cfg );
  Tx4.update_config4(cfg);
  Rx4.update_config4(cfg);   
endfunction : update_config4

`endif
