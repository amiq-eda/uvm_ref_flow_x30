/*-------------------------------------------------------------------------
File3 name   : uart_env3.sv
Title3       : UART3 UVC3 env3 file 
Project3     :
Created3     :
Description3 : Creates3 and configures3 the UART3 UVC3
Notes3       :  
----------------------------------------------------------------------*/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------


`ifndef UART_ENV_SVH3
`define UART_ENV_SVH3

class uart_env3 extends uvm_env;

  // Virtual Interface3 variable
  virtual interface uart_if3 vif3;

  // Environment3 Configuration3 Paramters3
  uart_config3 cfg;         // UART3 configuration object
  bit checks_enable3 = 1;
  bit coverage_enable3 = 1;
   
  // Components of the environment3
  uart_tx_agent3 Tx3;
  uart_rx_agent3 Rx3;

  // Used3 to update the config when it is updated during simulation
  uvm_analysis_imp#(uart_config3, uart_env3) dut_cfg_port_in3;

  // This3 macro3 provide3 implementation of get_type_name() and create()
  `uvm_component_utils_begin(uart_env3)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable3, UVM_DEFAULT)
    `uvm_field_int(coverage_enable3, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor3 - required3 UVM syntax3
  function new( string name, uvm_component parent);
    super.new(name, parent);
    dut_cfg_port_in3 = new("dut_cfg_port_in3", this);
  endfunction

  // Additional3 class methods3
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables3();
  extern virtual function void write(uart_config3 cfg);
  extern virtual function void update_config3(uart_config3 cfg);

endclass : uart_env3

//UVM build_phase
function void uart_env3::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure3
  if ( cfg == null)
    if (!uvm_config_db#(uart_config3)::get(this, "", "cfg", cfg)) begin
      `uvm_info("NOCONFIG3", "No uart_config3, creating3...", UVM_MEDIUM)
      cfg = uart_config3::type_id::create("cfg", this);
      if (!cfg.randomize())
         `uvm_error("RNDFAIL3", "Could not randomize uart_config3 using default values")
      `uvm_info(get_type_name(), {"Printing3 cfg:\n", cfg.sprint()}, UVM_MEDIUM)
    end
  // Configure3 the sub-components3
  uvm_config_object::set(this, "Tx3*", "cfg", cfg);
  uvm_config_object::set(this, "Rx3*", "cfg", cfg);

  // Create3 sub-components3
  Tx3 = uart_tx_agent3::type_id::create("Tx3",this);
  Rx3 = uart_rx_agent3::type_id::create("Rx3",this);
endfunction : build_phase

//UVM connect_phase
function void uart_env3::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get3 the agent3's virtual interface if set via config
  if(!uvm_config_db#(virtual uart_if3)::get(this, "", "vif3", vif3))
    `uvm_error("NOVIF3",{"virtual interface must be set for: ",get_full_name(),".vif3"})
endfunction : connect_phase

// Function3 to assign the checks3 and coverage3 enable bits
task uart_env3::update_vif_enables3();
  // Make3 assignments3 at time 0 based on configuration
  vif3.has_checks3 <= checks_enable3;
  vif3.has_coverage <= coverage_enable3;
  forever begin
    @(checks_enable3 or coverage_enable3);
    vif3.has_checks3 <= checks_enable3;
    vif3.has_coverage <= coverage_enable3;
  end
endtask : update_vif_enables3

// UVM run_phase
task uart_env3::run_phase(uvm_phase phase);
  fork 
    update_vif_enables3(); 
  join
endtask : run_phase
  
// Update the config when RGM3 updates3?
function void uart_env3::write(input uart_config3 cfg );
  this.cfg = cfg;
  update_config3(cfg);
endfunction : write

// Update Agent3 config when config updates3
function void uart_env3::update_config3(input uart_config3 cfg );
  Tx3.update_config3(cfg);
  Rx3.update_config3(cfg);   
endfunction : update_config3

`endif
