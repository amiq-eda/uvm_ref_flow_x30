/*******************************************************************************
  FILE : apb_env8.sv
*******************************************************************************/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------

`ifndef APB_ENV_SV8
`define APB_ENV_SV8

//------------------------------------------------------------------------------
// CLASS8: apb_env8
//------------------------------------------------------------------------------

class apb_env8 extends uvm_env;

  // Virtual interface for this environment8. This8 should only be done if the
  // same interface is used for all masters8/slaves8 in the environment8. Otherwise8,
  // Each agent8 should have its interface independently8 set.
  protected virtual interface apb_if8 vif8;

  // Environment8 Configuration8 Parameters8
  apb_config8 cfg;     // APB8 configuration object

  // The following8 two8 bits are used to control8 whether8 checks8 and coverage8 are
  // done both in the bus monitor8 class and the interface.
  bit checks_enable8 = 1; 
  bit coverage_enable8 = 1;

  // Components of the environment8
  apb_monitor8 bus_monitor8;
  apb_collector8 bus_collector8;
  apb_master_agent8 master8;
  apb_slave_agent8 slaves8[];

  // Provide8 implementations8 of virtual methods8 such8 as get_type_name and create
  `uvm_component_utils_begin(apb_env8)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable8, UVM_DEFAULT)
    `uvm_field_int(coverage_enable8, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor8 - Required8 UVM syntax8
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional8 class methods8
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual function void update_config8(apb_config8 cfg);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables8();

endclass : apb_env8

// UVM build_phase
function void apb_env8::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Create8 the APB8 UVC8 configuration class if it has not been set
  if(cfg == null) //begin
    if (!uvm_config_db#(apb_config8)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG8", "Using default_apb_config8", UVM_MEDIUM)
    $cast(cfg, factory.create_object_by_name("default_apb_config8","cfg"));
  end
  // set the master8 config
  uvm_config_object::set(this, "*", "cfg", cfg); 
  // set the slave8 configs8
  foreach(cfg.slave_configs8[i]) begin
    string sname;
    sname = $psprintf("slave8[%0d]*", i); 
    uvm_config_object::set(this, sname, "cfg", cfg.slave_configs8[i]);
  end

  bus_monitor8 = apb_monitor8::type_id::create("bus_monitor8",this);
  bus_collector8 = apb_collector8::type_id::create("bus_collector8",this);
  master8 = apb_master_agent8::type_id::create(cfg.master_config8.name,this);
  slaves8 = new[cfg.slave_configs8.size()];
  for(int i = 0; i < cfg.slave_configs8.size(); i++) begin
    slaves8[i] = apb_slave_agent8::type_id::create($psprintf("slave8[%0d]", i), this);
  end

endfunction : build_phase

// UVM connect_phase
function void apb_env8::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get8 the virtual interface if set via get_config
  if (!uvm_config_db#(virtual apb_if8)::get(this, "", "vif8", vif8))
    `uvm_error("NOVIF8",{"virtual interface must be set for: ",get_full_name(),".vif8"})
  bus_collector8.item_collected_port8.connect(bus_monitor8.coll_mon_port8);
  bus_monitor8.addr_trans_port8.connect(bus_collector8.addr_trans_export8);
  master8.monitor8 = bus_monitor8;
  master8.collector8 = bus_collector8;
  foreach(slaves8[i]) begin
    slaves8[i].monitor8 = bus_monitor8;
    slaves8[i].collector8 = bus_collector8;
    if (slaves8[i].is_active == UVM_ACTIVE)
      slaves8[i].sequencer.addr_trans_port8.connect(bus_monitor8.addr_trans_export8);
  end
endfunction : connect_phase

// UVM start_of_simulation_phase
function void apb_env8::start_of_simulation_phase(uvm_phase phase);
  set_report_id_action_hier("CFGOVR8", UVM_DISPLAY);
  set_report_id_action_hier("CFGSET8", UVM_DISPLAY);
  check_config_usage();
endfunction : start_of_simulation_phase

// update_config8() method
function void apb_env8::update_config8(apb_config8 cfg);
  bus_monitor8.cfg = cfg;
  bus_collector8.cfg = cfg;
  master8.update_config8(cfg);
  foreach(slaves8[i])
    slaves8[i].update_config8(cfg.slave_configs8[i]);
endfunction : update_config8

// update_vif_enables8
task apb_env8::update_vif_enables8();
  vif8.has_checks8 <= checks_enable8;
  vif8.has_coverage <= coverage_enable8;
  forever begin
    @(checks_enable8 || coverage_enable8);
    vif8.has_checks8 <= checks_enable8;
    vif8.has_coverage <= coverage_enable8;
  end
endtask : update_vif_enables8

//UVM run_phase()
task apb_env8::run_phase(uvm_phase phase);
  fork
    update_vif_enables8();
  join
endtask : run_phase

`endif // APB_ENV_SV8
