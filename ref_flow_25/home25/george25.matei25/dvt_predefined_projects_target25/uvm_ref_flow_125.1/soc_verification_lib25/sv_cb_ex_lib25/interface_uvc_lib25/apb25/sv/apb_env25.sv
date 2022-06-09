/*******************************************************************************
  FILE : apb_env25.sv
*******************************************************************************/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------

`ifndef APB_ENV_SV25
`define APB_ENV_SV25

//------------------------------------------------------------------------------
// CLASS25: apb_env25
//------------------------------------------------------------------------------

class apb_env25 extends uvm_env;

  // Virtual interface for this environment25. This25 should only be done if the
  // same interface is used for all masters25/slaves25 in the environment25. Otherwise25,
  // Each agent25 should have its interface independently25 set.
  protected virtual interface apb_if25 vif25;

  // Environment25 Configuration25 Parameters25
  apb_config25 cfg;     // APB25 configuration object

  // The following25 two25 bits are used to control25 whether25 checks25 and coverage25 are
  // done both in the bus monitor25 class and the interface.
  bit checks_enable25 = 1; 
  bit coverage_enable25 = 1;

  // Components of the environment25
  apb_monitor25 bus_monitor25;
  apb_collector25 bus_collector25;
  apb_master_agent25 master25;
  apb_slave_agent25 slaves25[];

  // Provide25 implementations25 of virtual methods25 such25 as get_type_name and create
  `uvm_component_utils_begin(apb_env25)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable25, UVM_DEFAULT)
    `uvm_field_int(coverage_enable25, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor25 - Required25 UVM syntax25
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional25 class methods25
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual function void update_config25(apb_config25 cfg);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables25();

endclass : apb_env25

// UVM build_phase
function void apb_env25::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Create25 the APB25 UVC25 configuration class if it has not been set
  if(cfg == null) //begin
    if (!uvm_config_db#(apb_config25)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG25", "Using default_apb_config25", UVM_MEDIUM)
    $cast(cfg, factory.create_object_by_name("default_apb_config25","cfg"));
  end
  // set the master25 config
  uvm_config_object::set(this, "*", "cfg", cfg); 
  // set the slave25 configs25
  foreach(cfg.slave_configs25[i]) begin
    string sname;
    sname = $psprintf("slave25[%0d]*", i); 
    uvm_config_object::set(this, sname, "cfg", cfg.slave_configs25[i]);
  end

  bus_monitor25 = apb_monitor25::type_id::create("bus_monitor25",this);
  bus_collector25 = apb_collector25::type_id::create("bus_collector25",this);
  master25 = apb_master_agent25::type_id::create(cfg.master_config25.name,this);
  slaves25 = new[cfg.slave_configs25.size()];
  for(int i = 0; i < cfg.slave_configs25.size(); i++) begin
    slaves25[i] = apb_slave_agent25::type_id::create($psprintf("slave25[%0d]", i), this);
  end

endfunction : build_phase

// UVM connect_phase
function void apb_env25::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get25 the virtual interface if set via get_config
  if (!uvm_config_db#(virtual apb_if25)::get(this, "", "vif25", vif25))
    `uvm_error("NOVIF25",{"virtual interface must be set for: ",get_full_name(),".vif25"})
  bus_collector25.item_collected_port25.connect(bus_monitor25.coll_mon_port25);
  bus_monitor25.addr_trans_port25.connect(bus_collector25.addr_trans_export25);
  master25.monitor25 = bus_monitor25;
  master25.collector25 = bus_collector25;
  foreach(slaves25[i]) begin
    slaves25[i].monitor25 = bus_monitor25;
    slaves25[i].collector25 = bus_collector25;
    if (slaves25[i].is_active == UVM_ACTIVE)
      slaves25[i].sequencer.addr_trans_port25.connect(bus_monitor25.addr_trans_export25);
  end
endfunction : connect_phase

// UVM start_of_simulation_phase
function void apb_env25::start_of_simulation_phase(uvm_phase phase);
  set_report_id_action_hier("CFGOVR25", UVM_DISPLAY);
  set_report_id_action_hier("CFGSET25", UVM_DISPLAY);
  check_config_usage();
endfunction : start_of_simulation_phase

// update_config25() method
function void apb_env25::update_config25(apb_config25 cfg);
  bus_monitor25.cfg = cfg;
  bus_collector25.cfg = cfg;
  master25.update_config25(cfg);
  foreach(slaves25[i])
    slaves25[i].update_config25(cfg.slave_configs25[i]);
endfunction : update_config25

// update_vif_enables25
task apb_env25::update_vif_enables25();
  vif25.has_checks25 <= checks_enable25;
  vif25.has_coverage <= coverage_enable25;
  forever begin
    @(checks_enable25 || coverage_enable25);
    vif25.has_checks25 <= checks_enable25;
    vif25.has_coverage <= coverage_enable25;
  end
endtask : update_vif_enables25

//UVM run_phase()
task apb_env25::run_phase(uvm_phase phase);
  fork
    update_vif_enables25();
  join
endtask : run_phase

`endif // APB_ENV_SV25
