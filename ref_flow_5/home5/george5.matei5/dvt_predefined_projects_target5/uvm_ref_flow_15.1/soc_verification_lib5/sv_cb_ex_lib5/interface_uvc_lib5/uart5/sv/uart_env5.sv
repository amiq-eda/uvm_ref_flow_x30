/*-------------------------------------------------------------------------
File5 name   : uart_env5.sv
Title5       : UART5 UVC5 env5 file 
Project5     :
Created5     :
Description5 : Creates5 and configures5 the UART5 UVC5
Notes5       :  
----------------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------


`ifndef UART_ENV_SVH5
`define UART_ENV_SVH5

class uart_env5 extends uvm_env;

  // Virtual Interface5 variable
  virtual interface uart_if5 vif5;

  // Environment5 Configuration5 Paramters5
  uart_config5 cfg;         // UART5 configuration object
  bit checks_enable5 = 1;
  bit coverage_enable5 = 1;
   
  // Components of the environment5
  uart_tx_agent5 Tx5;
  uart_rx_agent5 Rx5;

  // Used5 to update the config when it is updated during simulation
  uvm_analysis_imp#(uart_config5, uart_env5) dut_cfg_port_in5;

  // This5 macro5 provide5 implementation of get_type_name() and create()
  `uvm_component_utils_begin(uart_env5)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable5, UVM_DEFAULT)
    `uvm_field_int(coverage_enable5, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor5 - required5 UVM syntax5
  function new( string name, uvm_component parent);
    super.new(name, parent);
    dut_cfg_port_in5 = new("dut_cfg_port_in5", this);
  endfunction

  // Additional5 class methods5
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables5();
  extern virtual function void write(uart_config5 cfg);
  extern virtual function void update_config5(uart_config5 cfg);

endclass : uart_env5

//UVM build_phase
function void uart_env5::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure5
  if ( cfg == null)
    if (!uvm_config_db#(uart_config5)::get(this, "", "cfg", cfg)) begin
      `uvm_info("NOCONFIG5", "No uart_config5, creating5...", UVM_MEDIUM)
      cfg = uart_config5::type_id::create("cfg", this);
      if (!cfg.randomize())
         `uvm_error("RNDFAIL5", "Could not randomize uart_config5 using default values")
      `uvm_info(get_type_name(), {"Printing5 cfg:\n", cfg.sprint()}, UVM_MEDIUM)
    end
  // Configure5 the sub-components5
  uvm_config_object::set(this, "Tx5*", "cfg", cfg);
  uvm_config_object::set(this, "Rx5*", "cfg", cfg);

  // Create5 sub-components5
  Tx5 = uart_tx_agent5::type_id::create("Tx5",this);
  Rx5 = uart_rx_agent5::type_id::create("Rx5",this);
endfunction : build_phase

//UVM connect_phase
function void uart_env5::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get5 the agent5's virtual interface if set via config
  if(!uvm_config_db#(virtual uart_if5)::get(this, "", "vif5", vif5))
    `uvm_error("NOVIF5",{"virtual interface must be set for: ",get_full_name(),".vif5"})
endfunction : connect_phase

// Function5 to assign the checks5 and coverage5 enable bits
task uart_env5::update_vif_enables5();
  // Make5 assignments5 at time 0 based on configuration
  vif5.has_checks5 <= checks_enable5;
  vif5.has_coverage <= coverage_enable5;
  forever begin
    @(checks_enable5 or coverage_enable5);
    vif5.has_checks5 <= checks_enable5;
    vif5.has_coverage <= coverage_enable5;
  end
endtask : update_vif_enables5

// UVM run_phase
task uart_env5::run_phase(uvm_phase phase);
  fork 
    update_vif_enables5(); 
  join
endtask : run_phase
  
// Update the config when RGM5 updates5?
function void uart_env5::write(input uart_config5 cfg );
  this.cfg = cfg;
  update_config5(cfg);
endfunction : write

// Update Agent5 config when config updates5
function void uart_env5::update_config5(input uart_config5 cfg );
  Tx5.update_config5(cfg);
  Rx5.update_config5(cfg);   
endfunction : update_config5

`endif
