/*-------------------------------------------------------------------------
File19 name   : uart_env19.sv
Title19       : UART19 UVC19 env19 file 
Project19     :
Created19     :
Description19 : Creates19 and configures19 the UART19 UVC19
Notes19       :  
----------------------------------------------------------------------*/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------


`ifndef UART_ENV_SVH19
`define UART_ENV_SVH19

class uart_env19 extends uvm_env;

  // Virtual Interface19 variable
  virtual interface uart_if19 vif19;

  // Environment19 Configuration19 Paramters19
  uart_config19 cfg;         // UART19 configuration object
  bit checks_enable19 = 1;
  bit coverage_enable19 = 1;
   
  // Components of the environment19
  uart_tx_agent19 Tx19;
  uart_rx_agent19 Rx19;

  // Used19 to update the config when it is updated during simulation
  uvm_analysis_imp#(uart_config19, uart_env19) dut_cfg_port_in19;

  // This19 macro19 provide19 implementation of get_type_name() and create()
  `uvm_component_utils_begin(uart_env19)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable19, UVM_DEFAULT)
    `uvm_field_int(coverage_enable19, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor19 - required19 UVM syntax19
  function new( string name, uvm_component parent);
    super.new(name, parent);
    dut_cfg_port_in19 = new("dut_cfg_port_in19", this);
  endfunction

  // Additional19 class methods19
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables19();
  extern virtual function void write(uart_config19 cfg);
  extern virtual function void update_config19(uart_config19 cfg);

endclass : uart_env19

//UVM build_phase
function void uart_env19::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure19
  if ( cfg == null)
    if (!uvm_config_db#(uart_config19)::get(this, "", "cfg", cfg)) begin
      `uvm_info("NOCONFIG19", "No uart_config19, creating19...", UVM_MEDIUM)
      cfg = uart_config19::type_id::create("cfg", this);
      if (!cfg.randomize())
         `uvm_error("RNDFAIL19", "Could not randomize uart_config19 using default values")
      `uvm_info(get_type_name(), {"Printing19 cfg:\n", cfg.sprint()}, UVM_MEDIUM)
    end
  // Configure19 the sub-components19
  uvm_config_object::set(this, "Tx19*", "cfg", cfg);
  uvm_config_object::set(this, "Rx19*", "cfg", cfg);

  // Create19 sub-components19
  Tx19 = uart_tx_agent19::type_id::create("Tx19",this);
  Rx19 = uart_rx_agent19::type_id::create("Rx19",this);
endfunction : build_phase

//UVM connect_phase
function void uart_env19::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get19 the agent19's virtual interface if set via config
  if(!uvm_config_db#(virtual uart_if19)::get(this, "", "vif19", vif19))
    `uvm_error("NOVIF19",{"virtual interface must be set for: ",get_full_name(),".vif19"})
endfunction : connect_phase

// Function19 to assign the checks19 and coverage19 enable bits
task uart_env19::update_vif_enables19();
  // Make19 assignments19 at time 0 based on configuration
  vif19.has_checks19 <= checks_enable19;
  vif19.has_coverage <= coverage_enable19;
  forever begin
    @(checks_enable19 or coverage_enable19);
    vif19.has_checks19 <= checks_enable19;
    vif19.has_coverage <= coverage_enable19;
  end
endtask : update_vif_enables19

// UVM run_phase
task uart_env19::run_phase(uvm_phase phase);
  fork 
    update_vif_enables19(); 
  join
endtask : run_phase
  
// Update the config when RGM19 updates19?
function void uart_env19::write(input uart_config19 cfg );
  this.cfg = cfg;
  update_config19(cfg);
endfunction : write

// Update Agent19 config when config updates19
function void uart_env19::update_config19(input uart_config19 cfg );
  Tx19.update_config19(cfg);
  Rx19.update_config19(cfg);   
endfunction : update_config19

`endif
