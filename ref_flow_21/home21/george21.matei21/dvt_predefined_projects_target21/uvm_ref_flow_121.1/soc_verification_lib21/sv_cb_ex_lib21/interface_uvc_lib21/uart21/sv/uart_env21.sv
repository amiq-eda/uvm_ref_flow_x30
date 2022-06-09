/*-------------------------------------------------------------------------
File21 name   : uart_env21.sv
Title21       : UART21 UVC21 env21 file 
Project21     :
Created21     :
Description21 : Creates21 and configures21 the UART21 UVC21
Notes21       :  
----------------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------


`ifndef UART_ENV_SVH21
`define UART_ENV_SVH21

class uart_env21 extends uvm_env;

  // Virtual Interface21 variable
  virtual interface uart_if21 vif21;

  // Environment21 Configuration21 Paramters21
  uart_config21 cfg;         // UART21 configuration object
  bit checks_enable21 = 1;
  bit coverage_enable21 = 1;
   
  // Components of the environment21
  uart_tx_agent21 Tx21;
  uart_rx_agent21 Rx21;

  // Used21 to update the config when it is updated during simulation
  uvm_analysis_imp#(uart_config21, uart_env21) dut_cfg_port_in21;

  // This21 macro21 provide21 implementation of get_type_name() and create()
  `uvm_component_utils_begin(uart_env21)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable21, UVM_DEFAULT)
    `uvm_field_int(coverage_enable21, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor21 - required21 UVM syntax21
  function new( string name, uvm_component parent);
    super.new(name, parent);
    dut_cfg_port_in21 = new("dut_cfg_port_in21", this);
  endfunction

  // Additional21 class methods21
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables21();
  extern virtual function void write(uart_config21 cfg);
  extern virtual function void update_config21(uart_config21 cfg);

endclass : uart_env21

//UVM build_phase
function void uart_env21::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure21
  if ( cfg == null)
    if (!uvm_config_db#(uart_config21)::get(this, "", "cfg", cfg)) begin
      `uvm_info("NOCONFIG21", "No uart_config21, creating21...", UVM_MEDIUM)
      cfg = uart_config21::type_id::create("cfg", this);
      if (!cfg.randomize())
         `uvm_error("RNDFAIL21", "Could not randomize uart_config21 using default values")
      `uvm_info(get_type_name(), {"Printing21 cfg:\n", cfg.sprint()}, UVM_MEDIUM)
    end
  // Configure21 the sub-components21
  uvm_config_object::set(this, "Tx21*", "cfg", cfg);
  uvm_config_object::set(this, "Rx21*", "cfg", cfg);

  // Create21 sub-components21
  Tx21 = uart_tx_agent21::type_id::create("Tx21",this);
  Rx21 = uart_rx_agent21::type_id::create("Rx21",this);
endfunction : build_phase

//UVM connect_phase
function void uart_env21::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get21 the agent21's virtual interface if set via config
  if(!uvm_config_db#(virtual uart_if21)::get(this, "", "vif21", vif21))
    `uvm_error("NOVIF21",{"virtual interface must be set for: ",get_full_name(),".vif21"})
endfunction : connect_phase

// Function21 to assign the checks21 and coverage21 enable bits
task uart_env21::update_vif_enables21();
  // Make21 assignments21 at time 0 based on configuration
  vif21.has_checks21 <= checks_enable21;
  vif21.has_coverage <= coverage_enable21;
  forever begin
    @(checks_enable21 or coverage_enable21);
    vif21.has_checks21 <= checks_enable21;
    vif21.has_coverage <= coverage_enable21;
  end
endtask : update_vif_enables21

// UVM run_phase
task uart_env21::run_phase(uvm_phase phase);
  fork 
    update_vif_enables21(); 
  join
endtask : run_phase
  
// Update the config when RGM21 updates21?
function void uart_env21::write(input uart_config21 cfg );
  this.cfg = cfg;
  update_config21(cfg);
endfunction : write

// Update Agent21 config when config updates21
function void uart_env21::update_config21(input uart_config21 cfg );
  Tx21.update_config21(cfg);
  Rx21.update_config21(cfg);   
endfunction : update_config21

`endif
