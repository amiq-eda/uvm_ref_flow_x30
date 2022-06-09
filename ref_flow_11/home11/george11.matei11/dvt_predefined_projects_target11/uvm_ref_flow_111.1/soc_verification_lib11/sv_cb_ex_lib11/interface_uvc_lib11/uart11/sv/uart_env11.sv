/*-------------------------------------------------------------------------
File11 name   : uart_env11.sv
Title11       : UART11 UVC11 env11 file 
Project11     :
Created11     :
Description11 : Creates11 and configures11 the UART11 UVC11
Notes11       :  
----------------------------------------------------------------------*/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------


`ifndef UART_ENV_SVH11
`define UART_ENV_SVH11

class uart_env11 extends uvm_env;

  // Virtual Interface11 variable
  virtual interface uart_if11 vif11;

  // Environment11 Configuration11 Paramters11
  uart_config11 cfg;         // UART11 configuration object
  bit checks_enable11 = 1;
  bit coverage_enable11 = 1;
   
  // Components of the environment11
  uart_tx_agent11 Tx11;
  uart_rx_agent11 Rx11;

  // Used11 to update the config when it is updated during simulation
  uvm_analysis_imp#(uart_config11, uart_env11) dut_cfg_port_in11;

  // This11 macro11 provide11 implementation of get_type_name() and create()
  `uvm_component_utils_begin(uart_env11)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable11, UVM_DEFAULT)
    `uvm_field_int(coverage_enable11, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor11 - required11 UVM syntax11
  function new( string name, uvm_component parent);
    super.new(name, parent);
    dut_cfg_port_in11 = new("dut_cfg_port_in11", this);
  endfunction

  // Additional11 class methods11
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables11();
  extern virtual function void write(uart_config11 cfg);
  extern virtual function void update_config11(uart_config11 cfg);

endclass : uart_env11

//UVM build_phase
function void uart_env11::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure11
  if ( cfg == null)
    if (!uvm_config_db#(uart_config11)::get(this, "", "cfg", cfg)) begin
      `uvm_info("NOCONFIG11", "No uart_config11, creating11...", UVM_MEDIUM)
      cfg = uart_config11::type_id::create("cfg", this);
      if (!cfg.randomize())
         `uvm_error("RNDFAIL11", "Could not randomize uart_config11 using default values")
      `uvm_info(get_type_name(), {"Printing11 cfg:\n", cfg.sprint()}, UVM_MEDIUM)
    end
  // Configure11 the sub-components11
  uvm_config_object::set(this, "Tx11*", "cfg", cfg);
  uvm_config_object::set(this, "Rx11*", "cfg", cfg);

  // Create11 sub-components11
  Tx11 = uart_tx_agent11::type_id::create("Tx11",this);
  Rx11 = uart_rx_agent11::type_id::create("Rx11",this);
endfunction : build_phase

//UVM connect_phase
function void uart_env11::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get11 the agent11's virtual interface if set via config
  if(!uvm_config_db#(virtual uart_if11)::get(this, "", "vif11", vif11))
    `uvm_error("NOVIF11",{"virtual interface must be set for: ",get_full_name(),".vif11"})
endfunction : connect_phase

// Function11 to assign the checks11 and coverage11 enable bits
task uart_env11::update_vif_enables11();
  // Make11 assignments11 at time 0 based on configuration
  vif11.has_checks11 <= checks_enable11;
  vif11.has_coverage <= coverage_enable11;
  forever begin
    @(checks_enable11 or coverage_enable11);
    vif11.has_checks11 <= checks_enable11;
    vif11.has_coverage <= coverage_enable11;
  end
endtask : update_vif_enables11

// UVM run_phase
task uart_env11::run_phase(uvm_phase phase);
  fork 
    update_vif_enables11(); 
  join
endtask : run_phase
  
// Update the config when RGM11 updates11?
function void uart_env11::write(input uart_config11 cfg );
  this.cfg = cfg;
  update_config11(cfg);
endfunction : write

// Update Agent11 config when config updates11
function void uart_env11::update_config11(input uart_config11 cfg );
  Tx11.update_config11(cfg);
  Rx11.update_config11(cfg);   
endfunction : update_config11

`endif
