/*******************************************************************************
  FILE : apb_env13.sv
*******************************************************************************/
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

`ifndef APB_ENV_SV13
`define APB_ENV_SV13

//------------------------------------------------------------------------------
// CLASS13: apb_env13
//------------------------------------------------------------------------------

class apb_env13 extends uvm_env;

  // Virtual interface for this environment13. This13 should only be done if the
  // same interface is used for all masters13/slaves13 in the environment13. Otherwise13,
  // Each agent13 should have its interface independently13 set.
  protected virtual interface apb_if13 vif13;

  // Environment13 Configuration13 Parameters13
  apb_config13 cfg;     // APB13 configuration object

  // The following13 two13 bits are used to control13 whether13 checks13 and coverage13 are
  // done both in the bus monitor13 class and the interface.
  bit checks_enable13 = 1; 
  bit coverage_enable13 = 1;

  // Components of the environment13
  apb_monitor13 bus_monitor13;
  apb_collector13 bus_collector13;
  apb_master_agent13 master13;
  apb_slave_agent13 slaves13[];

  // Provide13 implementations13 of virtual methods13 such13 as get_type_name and create
  `uvm_component_utils_begin(apb_env13)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable13, UVM_DEFAULT)
    `uvm_field_int(coverage_enable13, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor13 - Required13 UVM syntax13
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional13 class methods13
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual function void update_config13(apb_config13 cfg);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables13();

endclass : apb_env13

// UVM build_phase
function void apb_env13::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Create13 the APB13 UVC13 configuration class if it has not been set
  if(cfg == null) //begin
    if (!uvm_config_db#(apb_config13)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG13", "Using default_apb_config13", UVM_MEDIUM)
    $cast(cfg, factory.create_object_by_name("default_apb_config13","cfg"));
  end
  // set the master13 config
  uvm_config_object::set(this, "*", "cfg", cfg); 
  // set the slave13 configs13
  foreach(cfg.slave_configs13[i]) begin
    string sname;
    sname = $psprintf("slave13[%0d]*", i); 
    uvm_config_object::set(this, sname, "cfg", cfg.slave_configs13[i]);
  end

  bus_monitor13 = apb_monitor13::type_id::create("bus_monitor13",this);
  bus_collector13 = apb_collector13::type_id::create("bus_collector13",this);
  master13 = apb_master_agent13::type_id::create(cfg.master_config13.name,this);
  slaves13 = new[cfg.slave_configs13.size()];
  for(int i = 0; i < cfg.slave_configs13.size(); i++) begin
    slaves13[i] = apb_slave_agent13::type_id::create($psprintf("slave13[%0d]", i), this);
  end

endfunction : build_phase

// UVM connect_phase
function void apb_env13::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get13 the virtual interface if set via get_config
  if (!uvm_config_db#(virtual apb_if13)::get(this, "", "vif13", vif13))
    `uvm_error("NOVIF13",{"virtual interface must be set for: ",get_full_name(),".vif13"})
  bus_collector13.item_collected_port13.connect(bus_monitor13.coll_mon_port13);
  bus_monitor13.addr_trans_port13.connect(bus_collector13.addr_trans_export13);
  master13.monitor13 = bus_monitor13;
  master13.collector13 = bus_collector13;
  foreach(slaves13[i]) begin
    slaves13[i].monitor13 = bus_monitor13;
    slaves13[i].collector13 = bus_collector13;
    if (slaves13[i].is_active == UVM_ACTIVE)
      slaves13[i].sequencer.addr_trans_port13.connect(bus_monitor13.addr_trans_export13);
  end
endfunction : connect_phase

// UVM start_of_simulation_phase
function void apb_env13::start_of_simulation_phase(uvm_phase phase);
  set_report_id_action_hier("CFGOVR13", UVM_DISPLAY);
  set_report_id_action_hier("CFGSET13", UVM_DISPLAY);
  check_config_usage();
endfunction : start_of_simulation_phase

// update_config13() method
function void apb_env13::update_config13(apb_config13 cfg);
  bus_monitor13.cfg = cfg;
  bus_collector13.cfg = cfg;
  master13.update_config13(cfg);
  foreach(slaves13[i])
    slaves13[i].update_config13(cfg.slave_configs13[i]);
endfunction : update_config13

// update_vif_enables13
task apb_env13::update_vif_enables13();
  vif13.has_checks13 <= checks_enable13;
  vif13.has_coverage <= coverage_enable13;
  forever begin
    @(checks_enable13 || coverage_enable13);
    vif13.has_checks13 <= checks_enable13;
    vif13.has_coverage <= coverage_enable13;
  end
endtask : update_vif_enables13

//UVM run_phase()
task apb_env13::run_phase(uvm_phase phase);
  fork
    update_vif_enables13();
  join
endtask : run_phase

`endif // APB_ENV_SV13
