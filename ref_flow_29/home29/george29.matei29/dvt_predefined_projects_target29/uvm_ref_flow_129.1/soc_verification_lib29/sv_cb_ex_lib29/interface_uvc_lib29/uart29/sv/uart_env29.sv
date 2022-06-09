/*-------------------------------------------------------------------------
File29 name   : uart_env29.sv
Title29       : UART29 UVC29 env29 file 
Project29     :
Created29     :
Description29 : Creates29 and configures29 the UART29 UVC29
Notes29       :  
----------------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------


`ifndef UART_ENV_SVH29
`define UART_ENV_SVH29

class uart_env29 extends uvm_env;

  // Virtual Interface29 variable
  virtual interface uart_if29 vif29;

  // Environment29 Configuration29 Paramters29
  uart_config29 cfg;         // UART29 configuration object
  bit checks_enable29 = 1;
  bit coverage_enable29 = 1;
   
  // Components of the environment29
  uart_tx_agent29 Tx29;
  uart_rx_agent29 Rx29;

  // Used29 to update the config when it is updated during simulation
  uvm_analysis_imp#(uart_config29, uart_env29) dut_cfg_port_in29;

  // This29 macro29 provide29 implementation of get_type_name() and create()
  `uvm_component_utils_begin(uart_env29)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable29, UVM_DEFAULT)
    `uvm_field_int(coverage_enable29, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor29 - required29 UVM syntax29
  function new( string name, uvm_component parent);
    super.new(name, parent);
    dut_cfg_port_in29 = new("dut_cfg_port_in29", this);
  endfunction

  // Additional29 class methods29
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables29();
  extern virtual function void write(uart_config29 cfg);
  extern virtual function void update_config29(uart_config29 cfg);

endclass : uart_env29

//UVM build_phase
function void uart_env29::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure29
  if ( cfg == null)
    if (!uvm_config_db#(uart_config29)::get(this, "", "cfg", cfg)) begin
      `uvm_info("NOCONFIG29", "No uart_config29, creating29...", UVM_MEDIUM)
      cfg = uart_config29::type_id::create("cfg", this);
      if (!cfg.randomize())
         `uvm_error("RNDFAIL29", "Could not randomize uart_config29 using default values")
      `uvm_info(get_type_name(), {"Printing29 cfg:\n", cfg.sprint()}, UVM_MEDIUM)
    end
  // Configure29 the sub-components29
  uvm_config_object::set(this, "Tx29*", "cfg", cfg);
  uvm_config_object::set(this, "Rx29*", "cfg", cfg);

  // Create29 sub-components29
  Tx29 = uart_tx_agent29::type_id::create("Tx29",this);
  Rx29 = uart_rx_agent29::type_id::create("Rx29",this);
endfunction : build_phase

//UVM connect_phase
function void uart_env29::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get29 the agent29's virtual interface if set via config
  if(!uvm_config_db#(virtual uart_if29)::get(this, "", "vif29", vif29))
    `uvm_error("NOVIF29",{"virtual interface must be set for: ",get_full_name(),".vif29"})
endfunction : connect_phase

// Function29 to assign the checks29 and coverage29 enable bits
task uart_env29::update_vif_enables29();
  // Make29 assignments29 at time 0 based on configuration
  vif29.has_checks29 <= checks_enable29;
  vif29.has_coverage <= coverage_enable29;
  forever begin
    @(checks_enable29 or coverage_enable29);
    vif29.has_checks29 <= checks_enable29;
    vif29.has_coverage <= coverage_enable29;
  end
endtask : update_vif_enables29

// UVM run_phase
task uart_env29::run_phase(uvm_phase phase);
  fork 
    update_vif_enables29(); 
  join
endtask : run_phase
  
// Update the config when RGM29 updates29?
function void uart_env29::write(input uart_config29 cfg );
  this.cfg = cfg;
  update_config29(cfg);
endfunction : write

// Update Agent29 config when config updates29
function void uart_env29::update_config29(input uart_config29 cfg );
  Tx29.update_config29(cfg);
  Rx29.update_config29(cfg);   
endfunction : update_config29

`endif
