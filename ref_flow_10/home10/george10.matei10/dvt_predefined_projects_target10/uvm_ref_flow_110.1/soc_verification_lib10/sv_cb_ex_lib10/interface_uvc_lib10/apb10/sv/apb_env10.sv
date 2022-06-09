/*******************************************************************************
  FILE : apb_env10.sv
*******************************************************************************/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------

`ifndef APB_ENV_SV10
`define APB_ENV_SV10

//------------------------------------------------------------------------------
// CLASS10: apb_env10
//------------------------------------------------------------------------------

class apb_env10 extends uvm_env;

  // Virtual interface for this environment10. This10 should only be done if the
  // same interface is used for all masters10/slaves10 in the environment10. Otherwise10,
  // Each agent10 should have its interface independently10 set.
  protected virtual interface apb_if10 vif10;

  // Environment10 Configuration10 Parameters10
  apb_config10 cfg;     // APB10 configuration object

  // The following10 two10 bits are used to control10 whether10 checks10 and coverage10 are
  // done both in the bus monitor10 class and the interface.
  bit checks_enable10 = 1; 
  bit coverage_enable10 = 1;

  // Components of the environment10
  apb_monitor10 bus_monitor10;
  apb_collector10 bus_collector10;
  apb_master_agent10 master10;
  apb_slave_agent10 slaves10[];

  // Provide10 implementations10 of virtual methods10 such10 as get_type_name and create
  `uvm_component_utils_begin(apb_env10)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable10, UVM_DEFAULT)
    `uvm_field_int(coverage_enable10, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor10 - Required10 UVM syntax10
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional10 class methods10
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual function void update_config10(apb_config10 cfg);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables10();

endclass : apb_env10

// UVM build_phase
function void apb_env10::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Create10 the APB10 UVC10 configuration class if it has not been set
  if(cfg == null) //begin
    if (!uvm_config_db#(apb_config10)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG10", "Using default_apb_config10", UVM_MEDIUM)
    $cast(cfg, factory.create_object_by_name("default_apb_config10","cfg"));
  end
  // set the master10 config
  uvm_config_object::set(this, "*", "cfg", cfg); 
  // set the slave10 configs10
  foreach(cfg.slave_configs10[i]) begin
    string sname;
    sname = $psprintf("slave10[%0d]*", i); 
    uvm_config_object::set(this, sname, "cfg", cfg.slave_configs10[i]);
  end

  bus_monitor10 = apb_monitor10::type_id::create("bus_monitor10",this);
  bus_collector10 = apb_collector10::type_id::create("bus_collector10",this);
  master10 = apb_master_agent10::type_id::create(cfg.master_config10.name,this);
  slaves10 = new[cfg.slave_configs10.size()];
  for(int i = 0; i < cfg.slave_configs10.size(); i++) begin
    slaves10[i] = apb_slave_agent10::type_id::create($psprintf("slave10[%0d]", i), this);
  end

endfunction : build_phase

// UVM connect_phase
function void apb_env10::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get10 the virtual interface if set via get_config
  if (!uvm_config_db#(virtual apb_if10)::get(this, "", "vif10", vif10))
    `uvm_error("NOVIF10",{"virtual interface must be set for: ",get_full_name(),".vif10"})
  bus_collector10.item_collected_port10.connect(bus_monitor10.coll_mon_port10);
  bus_monitor10.addr_trans_port10.connect(bus_collector10.addr_trans_export10);
  master10.monitor10 = bus_monitor10;
  master10.collector10 = bus_collector10;
  foreach(slaves10[i]) begin
    slaves10[i].monitor10 = bus_monitor10;
    slaves10[i].collector10 = bus_collector10;
    if (slaves10[i].is_active == UVM_ACTIVE)
      slaves10[i].sequencer.addr_trans_port10.connect(bus_monitor10.addr_trans_export10);
  end
endfunction : connect_phase

// UVM start_of_simulation_phase
function void apb_env10::start_of_simulation_phase(uvm_phase phase);
  set_report_id_action_hier("CFGOVR10", UVM_DISPLAY);
  set_report_id_action_hier("CFGSET10", UVM_DISPLAY);
  check_config_usage();
endfunction : start_of_simulation_phase

// update_config10() method
function void apb_env10::update_config10(apb_config10 cfg);
  bus_monitor10.cfg = cfg;
  bus_collector10.cfg = cfg;
  master10.update_config10(cfg);
  foreach(slaves10[i])
    slaves10[i].update_config10(cfg.slave_configs10[i]);
endfunction : update_config10

// update_vif_enables10
task apb_env10::update_vif_enables10();
  vif10.has_checks10 <= checks_enable10;
  vif10.has_coverage <= coverage_enable10;
  forever begin
    @(checks_enable10 || coverage_enable10);
    vif10.has_checks10 <= checks_enable10;
    vif10.has_coverage <= coverage_enable10;
  end
endtask : update_vif_enables10

//UVM run_phase()
task apb_env10::run_phase(uvm_phase phase);
  fork
    update_vif_enables10();
  join
endtask : run_phase

`endif // APB_ENV_SV10
