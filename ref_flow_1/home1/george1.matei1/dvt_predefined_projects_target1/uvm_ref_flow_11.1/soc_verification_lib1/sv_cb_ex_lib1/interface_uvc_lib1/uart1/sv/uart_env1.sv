/*-------------------------------------------------------------------------
File1 name   : uart_env1.sv
Title1       : UART1 UVC1 env1 file 
Project1     :
Created1     :
Description1 : Creates1 and configures1 the UART1 UVC1
Notes1       :  
----------------------------------------------------------------------*/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------


`ifndef UART_ENV_SVH1
`define UART_ENV_SVH1

class uart_env1 extends uvm_env;

  // Virtual Interface1 variable
  virtual interface uart_if1 vif1;

  // Environment1 Configuration1 Paramters1
  uart_config1 cfg;         // UART1 configuration object
  bit checks_enable1 = 1;
  bit coverage_enable1 = 1;
   
  // Components of the environment1
  uart_tx_agent1 Tx1;
  uart_rx_agent1 Rx1;

  // Used1 to update the config when it is updated during simulation
  uvm_analysis_imp#(uart_config1, uart_env1) dut_cfg_port_in1;

  // This1 macro1 provide1 implementation of get_type_name() and create()
  `uvm_component_utils_begin(uart_env1)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable1, UVM_DEFAULT)
    `uvm_field_int(coverage_enable1, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor1 - required1 UVM syntax1
  function new( string name, uvm_component parent);
    super.new(name, parent);
    dut_cfg_port_in1 = new("dut_cfg_port_in1", this);
  endfunction

  // Additional1 class methods1
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables1();
  extern virtual function void write(uart_config1 cfg);
  extern virtual function void update_config1(uart_config1 cfg);

endclass : uart_env1

//UVM build_phase
function void uart_env1::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure1
  if ( cfg == null)
    if (!uvm_config_db#(uart_config1)::get(this, "", "cfg", cfg)) begin
      `uvm_info("NOCONFIG1", "No uart_config1, creating1...", UVM_MEDIUM)
      cfg = uart_config1::type_id::create("cfg", this);
      if (!cfg.randomize())
         `uvm_error("RNDFAIL1", "Could not randomize uart_config1 using default values")
      `uvm_info(get_type_name(), {"Printing1 cfg:\n", cfg.sprint()}, UVM_MEDIUM)
    end
  // Configure1 the sub-components1
  uvm_config_object::set(this, "Tx1*", "cfg", cfg);
  uvm_config_object::set(this, "Rx1*", "cfg", cfg);

  // Create1 sub-components1
  Tx1 = uart_tx_agent1::type_id::create("Tx1",this);
  Rx1 = uart_rx_agent1::type_id::create("Rx1",this);
endfunction : build_phase

//UVM connect_phase
function void uart_env1::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get1 the agent1's virtual interface if set via config
  if(!uvm_config_db#(virtual uart_if1)::get(this, "", "vif1", vif1))
    `uvm_error("NOVIF1",{"virtual interface must be set for: ",get_full_name(),".vif1"})
endfunction : connect_phase

// Function1 to assign the checks1 and coverage1 enable bits
task uart_env1::update_vif_enables1();
  // Make1 assignments1 at time 0 based on configuration
  vif1.has_checks1 <= checks_enable1;
  vif1.has_coverage <= coverage_enable1;
  forever begin
    @(checks_enable1 or coverage_enable1);
    vif1.has_checks1 <= checks_enable1;
    vif1.has_coverage <= coverage_enable1;
  end
endtask : update_vif_enables1

// UVM run_phase
task uart_env1::run_phase(uvm_phase phase);
  fork 
    update_vif_enables1(); 
  join
endtask : run_phase
  
// Update the config when RGM1 updates1?
function void uart_env1::write(input uart_config1 cfg );
  this.cfg = cfg;
  update_config1(cfg);
endfunction : write

// Update Agent1 config when config updates1
function void uart_env1::update_config1(input uart_config1 cfg );
  Tx1.update_config1(cfg);
  Rx1.update_config1(cfg);   
endfunction : update_config1

`endif
