/*-------------------------------------------------------------------------
File13 name   : uart_env13.sv
Title13       : UART13 UVC13 env13 file 
Project13     :
Created13     :
Description13 : Creates13 and configures13 the UART13 UVC13
Notes13       :  
----------------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------


`ifndef UART_ENV_SVH13
`define UART_ENV_SVH13

class uart_env13 extends uvm_env;

  // Virtual Interface13 variable
  virtual interface uart_if13 vif13;

  // Environment13 Configuration13 Paramters13
  uart_config13 cfg;         // UART13 configuration object
  bit checks_enable13 = 1;
  bit coverage_enable13 = 1;
   
  // Components of the environment13
  uart_tx_agent13 Tx13;
  uart_rx_agent13 Rx13;

  // Used13 to update the config when it is updated during simulation
  uvm_analysis_imp#(uart_config13, uart_env13) dut_cfg_port_in13;

  // This13 macro13 provide13 implementation of get_type_name() and create()
  `uvm_component_utils_begin(uart_env13)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable13, UVM_DEFAULT)
    `uvm_field_int(coverage_enable13, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor13 - required13 UVM syntax13
  function new( string name, uvm_component parent);
    super.new(name, parent);
    dut_cfg_port_in13 = new("dut_cfg_port_in13", this);
  endfunction

  // Additional13 class methods13
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables13();
  extern virtual function void write(uart_config13 cfg);
  extern virtual function void update_config13(uart_config13 cfg);

endclass : uart_env13

//UVM build_phase
function void uart_env13::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure13
  if ( cfg == null)
    if (!uvm_config_db#(uart_config13)::get(this, "", "cfg", cfg)) begin
      `uvm_info("NOCONFIG13", "No uart_config13, creating13...", UVM_MEDIUM)
      cfg = uart_config13::type_id::create("cfg", this);
      if (!cfg.randomize())
         `uvm_error("RNDFAIL13", "Could not randomize uart_config13 using default values")
      `uvm_info(get_type_name(), {"Printing13 cfg:\n", cfg.sprint()}, UVM_MEDIUM)
    end
  // Configure13 the sub-components13
  uvm_config_object::set(this, "Tx13*", "cfg", cfg);
  uvm_config_object::set(this, "Rx13*", "cfg", cfg);

  // Create13 sub-components13
  Tx13 = uart_tx_agent13::type_id::create("Tx13",this);
  Rx13 = uart_rx_agent13::type_id::create("Rx13",this);
endfunction : build_phase

//UVM connect_phase
function void uart_env13::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get13 the agent13's virtual interface if set via config
  if(!uvm_config_db#(virtual uart_if13)::get(this, "", "vif13", vif13))
    `uvm_error("NOVIF13",{"virtual interface must be set for: ",get_full_name(),".vif13"})
endfunction : connect_phase

// Function13 to assign the checks13 and coverage13 enable bits
task uart_env13::update_vif_enables13();
  // Make13 assignments13 at time 0 based on configuration
  vif13.has_checks13 <= checks_enable13;
  vif13.has_coverage <= coverage_enable13;
  forever begin
    @(checks_enable13 or coverage_enable13);
    vif13.has_checks13 <= checks_enable13;
    vif13.has_coverage <= coverage_enable13;
  end
endtask : update_vif_enables13

// UVM run_phase
task uart_env13::run_phase(uvm_phase phase);
  fork 
    update_vif_enables13(); 
  join
endtask : run_phase
  
// Update the config when RGM13 updates13?
function void uart_env13::write(input uart_config13 cfg );
  this.cfg = cfg;
  update_config13(cfg);
endfunction : write

// Update Agent13 config when config updates13
function void uart_env13::update_config13(input uart_config13 cfg );
  Tx13.update_config13(cfg);
  Rx13.update_config13(cfg);   
endfunction : update_config13

`endif
