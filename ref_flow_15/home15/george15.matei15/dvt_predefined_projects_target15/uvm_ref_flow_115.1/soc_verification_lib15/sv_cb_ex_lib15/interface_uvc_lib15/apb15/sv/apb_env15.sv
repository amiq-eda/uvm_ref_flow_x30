/*******************************************************************************
  FILE : apb_env15.sv
*******************************************************************************/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------

`ifndef APB_ENV_SV15
`define APB_ENV_SV15

//------------------------------------------------------------------------------
// CLASS15: apb_env15
//------------------------------------------------------------------------------

class apb_env15 extends uvm_env;

  // Virtual interface for this environment15. This15 should only be done if the
  // same interface is used for all masters15/slaves15 in the environment15. Otherwise15,
  // Each agent15 should have its interface independently15 set.
  protected virtual interface apb_if15 vif15;

  // Environment15 Configuration15 Parameters15
  apb_config15 cfg;     // APB15 configuration object

  // The following15 two15 bits are used to control15 whether15 checks15 and coverage15 are
  // done both in the bus monitor15 class and the interface.
  bit checks_enable15 = 1; 
  bit coverage_enable15 = 1;

  // Components of the environment15
  apb_monitor15 bus_monitor15;
  apb_collector15 bus_collector15;
  apb_master_agent15 master15;
  apb_slave_agent15 slaves15[];

  // Provide15 implementations15 of virtual methods15 such15 as get_type_name and create
  `uvm_component_utils_begin(apb_env15)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable15, UVM_DEFAULT)
    `uvm_field_int(coverage_enable15, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor15 - Required15 UVM syntax15
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional15 class methods15
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual function void update_config15(apb_config15 cfg);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables15();

endclass : apb_env15

// UVM build_phase
function void apb_env15::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Create15 the APB15 UVC15 configuration class if it has not been set
  if(cfg == null) //begin
    if (!uvm_config_db#(apb_config15)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG15", "Using default_apb_config15", UVM_MEDIUM)
    $cast(cfg, factory.create_object_by_name("default_apb_config15","cfg"));
  end
  // set the master15 config
  uvm_config_object::set(this, "*", "cfg", cfg); 
  // set the slave15 configs15
  foreach(cfg.slave_configs15[i]) begin
    string sname;
    sname = $psprintf("slave15[%0d]*", i); 
    uvm_config_object::set(this, sname, "cfg", cfg.slave_configs15[i]);
  end

  bus_monitor15 = apb_monitor15::type_id::create("bus_monitor15",this);
  bus_collector15 = apb_collector15::type_id::create("bus_collector15",this);
  master15 = apb_master_agent15::type_id::create(cfg.master_config15.name,this);
  slaves15 = new[cfg.slave_configs15.size()];
  for(int i = 0; i < cfg.slave_configs15.size(); i++) begin
    slaves15[i] = apb_slave_agent15::type_id::create($psprintf("slave15[%0d]", i), this);
  end

endfunction : build_phase

// UVM connect_phase
function void apb_env15::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get15 the virtual interface if set via get_config
  if (!uvm_config_db#(virtual apb_if15)::get(this, "", "vif15", vif15))
    `uvm_error("NOVIF15",{"virtual interface must be set for: ",get_full_name(),".vif15"})
  bus_collector15.item_collected_port15.connect(bus_monitor15.coll_mon_port15);
  bus_monitor15.addr_trans_port15.connect(bus_collector15.addr_trans_export15);
  master15.monitor15 = bus_monitor15;
  master15.collector15 = bus_collector15;
  foreach(slaves15[i]) begin
    slaves15[i].monitor15 = bus_monitor15;
    slaves15[i].collector15 = bus_collector15;
    if (slaves15[i].is_active == UVM_ACTIVE)
      slaves15[i].sequencer.addr_trans_port15.connect(bus_monitor15.addr_trans_export15);
  end
endfunction : connect_phase

// UVM start_of_simulation_phase
function void apb_env15::start_of_simulation_phase(uvm_phase phase);
  set_report_id_action_hier("CFGOVR15", UVM_DISPLAY);
  set_report_id_action_hier("CFGSET15", UVM_DISPLAY);
  check_config_usage();
endfunction : start_of_simulation_phase

// update_config15() method
function void apb_env15::update_config15(apb_config15 cfg);
  bus_monitor15.cfg = cfg;
  bus_collector15.cfg = cfg;
  master15.update_config15(cfg);
  foreach(slaves15[i])
    slaves15[i].update_config15(cfg.slave_configs15[i]);
endfunction : update_config15

// update_vif_enables15
task apb_env15::update_vif_enables15();
  vif15.has_checks15 <= checks_enable15;
  vif15.has_coverage <= coverage_enable15;
  forever begin
    @(checks_enable15 || coverage_enable15);
    vif15.has_checks15 <= checks_enable15;
    vif15.has_coverage <= coverage_enable15;
  end
endtask : update_vif_enables15

//UVM run_phase()
task apb_env15::run_phase(uvm_phase phase);
  fork
    update_vif_enables15();
  join
endtask : run_phase

`endif // APB_ENV_SV15
