/*******************************************************************************
  FILE : apb_env24.sv
*******************************************************************************/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------

`ifndef APB_ENV_SV24
`define APB_ENV_SV24

//------------------------------------------------------------------------------
// CLASS24: apb_env24
//------------------------------------------------------------------------------

class apb_env24 extends uvm_env;

  // Virtual interface for this environment24. This24 should only be done if the
  // same interface is used for all masters24/slaves24 in the environment24. Otherwise24,
  // Each agent24 should have its interface independently24 set.
  protected virtual interface apb_if24 vif24;

  // Environment24 Configuration24 Parameters24
  apb_config24 cfg;     // APB24 configuration object

  // The following24 two24 bits are used to control24 whether24 checks24 and coverage24 are
  // done both in the bus monitor24 class and the interface.
  bit checks_enable24 = 1; 
  bit coverage_enable24 = 1;

  // Components of the environment24
  apb_monitor24 bus_monitor24;
  apb_collector24 bus_collector24;
  apb_master_agent24 master24;
  apb_slave_agent24 slaves24[];

  // Provide24 implementations24 of virtual methods24 such24 as get_type_name and create
  `uvm_component_utils_begin(apb_env24)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable24, UVM_DEFAULT)
    `uvm_field_int(coverage_enable24, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor24 - Required24 UVM syntax24
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional24 class methods24
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual function void update_config24(apb_config24 cfg);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables24();

endclass : apb_env24

// UVM build_phase
function void apb_env24::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Create24 the APB24 UVC24 configuration class if it has not been set
  if(cfg == null) //begin
    if (!uvm_config_db#(apb_config24)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG24", "Using default_apb_config24", UVM_MEDIUM)
    $cast(cfg, factory.create_object_by_name("default_apb_config24","cfg"));
  end
  // set the master24 config
  uvm_config_object::set(this, "*", "cfg", cfg); 
  // set the slave24 configs24
  foreach(cfg.slave_configs24[i]) begin
    string sname;
    sname = $psprintf("slave24[%0d]*", i); 
    uvm_config_object::set(this, sname, "cfg", cfg.slave_configs24[i]);
  end

  bus_monitor24 = apb_monitor24::type_id::create("bus_monitor24",this);
  bus_collector24 = apb_collector24::type_id::create("bus_collector24",this);
  master24 = apb_master_agent24::type_id::create(cfg.master_config24.name,this);
  slaves24 = new[cfg.slave_configs24.size()];
  for(int i = 0; i < cfg.slave_configs24.size(); i++) begin
    slaves24[i] = apb_slave_agent24::type_id::create($psprintf("slave24[%0d]", i), this);
  end

endfunction : build_phase

// UVM connect_phase
function void apb_env24::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get24 the virtual interface if set via get_config
  if (!uvm_config_db#(virtual apb_if24)::get(this, "", "vif24", vif24))
    `uvm_error("NOVIF24",{"virtual interface must be set for: ",get_full_name(),".vif24"})
  bus_collector24.item_collected_port24.connect(bus_monitor24.coll_mon_port24);
  bus_monitor24.addr_trans_port24.connect(bus_collector24.addr_trans_export24);
  master24.monitor24 = bus_monitor24;
  master24.collector24 = bus_collector24;
  foreach(slaves24[i]) begin
    slaves24[i].monitor24 = bus_monitor24;
    slaves24[i].collector24 = bus_collector24;
    if (slaves24[i].is_active == UVM_ACTIVE)
      slaves24[i].sequencer.addr_trans_port24.connect(bus_monitor24.addr_trans_export24);
  end
endfunction : connect_phase

// UVM start_of_simulation_phase
function void apb_env24::start_of_simulation_phase(uvm_phase phase);
  set_report_id_action_hier("CFGOVR24", UVM_DISPLAY);
  set_report_id_action_hier("CFGSET24", UVM_DISPLAY);
  check_config_usage();
endfunction : start_of_simulation_phase

// update_config24() method
function void apb_env24::update_config24(apb_config24 cfg);
  bus_monitor24.cfg = cfg;
  bus_collector24.cfg = cfg;
  master24.update_config24(cfg);
  foreach(slaves24[i])
    slaves24[i].update_config24(cfg.slave_configs24[i]);
endfunction : update_config24

// update_vif_enables24
task apb_env24::update_vif_enables24();
  vif24.has_checks24 <= checks_enable24;
  vif24.has_coverage <= coverage_enable24;
  forever begin
    @(checks_enable24 || coverage_enable24);
    vif24.has_checks24 <= checks_enable24;
    vif24.has_coverage <= coverage_enable24;
  end
endtask : update_vif_enables24

//UVM run_phase()
task apb_env24::run_phase(uvm_phase phase);
  fork
    update_vif_enables24();
  join
endtask : run_phase

`endif // APB_ENV_SV24
