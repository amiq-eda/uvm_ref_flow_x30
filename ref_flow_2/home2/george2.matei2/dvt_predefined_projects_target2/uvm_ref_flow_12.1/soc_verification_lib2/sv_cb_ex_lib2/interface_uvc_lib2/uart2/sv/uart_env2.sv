/*-------------------------------------------------------------------------
File2 name   : uart_env2.sv
Title2       : UART2 UVC2 env2 file 
Project2     :
Created2     :
Description2 : Creates2 and configures2 the UART2 UVC2
Notes2       :  
----------------------------------------------------------------------*/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------


`ifndef UART_ENV_SVH2
`define UART_ENV_SVH2

class uart_env2 extends uvm_env;

  // Virtual Interface2 variable
  virtual interface uart_if2 vif2;

  // Environment2 Configuration2 Paramters2
  uart_config2 cfg;         // UART2 configuration object
  bit checks_enable2 = 1;
  bit coverage_enable2 = 1;
   
  // Components of the environment2
  uart_tx_agent2 Tx2;
  uart_rx_agent2 Rx2;

  // Used2 to update the config when it is updated during simulation
  uvm_analysis_imp#(uart_config2, uart_env2) dut_cfg_port_in2;

  // This2 macro2 provide2 implementation of get_type_name() and create()
  `uvm_component_utils_begin(uart_env2)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable2, UVM_DEFAULT)
    `uvm_field_int(coverage_enable2, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor2 - required2 UVM syntax2
  function new( string name, uvm_component parent);
    super.new(name, parent);
    dut_cfg_port_in2 = new("dut_cfg_port_in2", this);
  endfunction

  // Additional2 class methods2
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables2();
  extern virtual function void write(uart_config2 cfg);
  extern virtual function void update_config2(uart_config2 cfg);

endclass : uart_env2

//UVM build_phase
function void uart_env2::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure2
  if ( cfg == null)
    if (!uvm_config_db#(uart_config2)::get(this, "", "cfg", cfg)) begin
      `uvm_info("NOCONFIG2", "No uart_config2, creating2...", UVM_MEDIUM)
      cfg = uart_config2::type_id::create("cfg", this);
      if (!cfg.randomize())
         `uvm_error("RNDFAIL2", "Could not randomize uart_config2 using default values")
      `uvm_info(get_type_name(), {"Printing2 cfg:\n", cfg.sprint()}, UVM_MEDIUM)
    end
  // Configure2 the sub-components2
  uvm_config_object::set(this, "Tx2*", "cfg", cfg);
  uvm_config_object::set(this, "Rx2*", "cfg", cfg);

  // Create2 sub-components2
  Tx2 = uart_tx_agent2::type_id::create("Tx2",this);
  Rx2 = uart_rx_agent2::type_id::create("Rx2",this);
endfunction : build_phase

//UVM connect_phase
function void uart_env2::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get2 the agent2's virtual interface if set via config
  if(!uvm_config_db#(virtual uart_if2)::get(this, "", "vif2", vif2))
    `uvm_error("NOVIF2",{"virtual interface must be set for: ",get_full_name(),".vif2"})
endfunction : connect_phase

// Function2 to assign the checks2 and coverage2 enable bits
task uart_env2::update_vif_enables2();
  // Make2 assignments2 at time 0 based on configuration
  vif2.has_checks2 <= checks_enable2;
  vif2.has_coverage <= coverage_enable2;
  forever begin
    @(checks_enable2 or coverage_enable2);
    vif2.has_checks2 <= checks_enable2;
    vif2.has_coverage <= coverage_enable2;
  end
endtask : update_vif_enables2

// UVM run_phase
task uart_env2::run_phase(uvm_phase phase);
  fork 
    update_vif_enables2(); 
  join
endtask : run_phase
  
// Update the config when RGM2 updates2?
function void uart_env2::write(input uart_config2 cfg );
  this.cfg = cfg;
  update_config2(cfg);
endfunction : write

// Update Agent2 config when config updates2
function void uart_env2::update_config2(input uart_config2 cfg );
  Tx2.update_config2(cfg);
  Rx2.update_config2(cfg);   
endfunction : update_config2

`endif
