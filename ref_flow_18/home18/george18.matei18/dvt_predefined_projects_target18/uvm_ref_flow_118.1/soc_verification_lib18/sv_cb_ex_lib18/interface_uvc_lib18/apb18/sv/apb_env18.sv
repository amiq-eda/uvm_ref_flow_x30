/*******************************************************************************
  FILE : apb_env18.sv
*******************************************************************************/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------

`ifndef APB_ENV_SV18
`define APB_ENV_SV18

//------------------------------------------------------------------------------
// CLASS18: apb_env18
//------------------------------------------------------------------------------

class apb_env18 extends uvm_env;

  // Virtual interface for this environment18. This18 should only be done if the
  // same interface is used for all masters18/slaves18 in the environment18. Otherwise18,
  // Each agent18 should have its interface independently18 set.
  protected virtual interface apb_if18 vif18;

  // Environment18 Configuration18 Parameters18
  apb_config18 cfg;     // APB18 configuration object

  // The following18 two18 bits are used to control18 whether18 checks18 and coverage18 are
  // done both in the bus monitor18 class and the interface.
  bit checks_enable18 = 1; 
  bit coverage_enable18 = 1;

  // Components of the environment18
  apb_monitor18 bus_monitor18;
  apb_collector18 bus_collector18;
  apb_master_agent18 master18;
  apb_slave_agent18 slaves18[];

  // Provide18 implementations18 of virtual methods18 such18 as get_type_name and create
  `uvm_component_utils_begin(apb_env18)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable18, UVM_DEFAULT)
    `uvm_field_int(coverage_enable18, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor18 - Required18 UVM syntax18
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional18 class methods18
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual function void update_config18(apb_config18 cfg);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables18();

endclass : apb_env18

// UVM build_phase
function void apb_env18::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Create18 the APB18 UVC18 configuration class if it has not been set
  if(cfg == null) //begin
    if (!uvm_config_db#(apb_config18)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG18", "Using default_apb_config18", UVM_MEDIUM)
    $cast(cfg, factory.create_object_by_name("default_apb_config18","cfg"));
  end
  // set the master18 config
  uvm_config_object::set(this, "*", "cfg", cfg); 
  // set the slave18 configs18
  foreach(cfg.slave_configs18[i]) begin
    string sname;
    sname = $psprintf("slave18[%0d]*", i); 
    uvm_config_object::set(this, sname, "cfg", cfg.slave_configs18[i]);
  end

  bus_monitor18 = apb_monitor18::type_id::create("bus_monitor18",this);
  bus_collector18 = apb_collector18::type_id::create("bus_collector18",this);
  master18 = apb_master_agent18::type_id::create(cfg.master_config18.name,this);
  slaves18 = new[cfg.slave_configs18.size()];
  for(int i = 0; i < cfg.slave_configs18.size(); i++) begin
    slaves18[i] = apb_slave_agent18::type_id::create($psprintf("slave18[%0d]", i), this);
  end

endfunction : build_phase

// UVM connect_phase
function void apb_env18::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get18 the virtual interface if set via get_config
  if (!uvm_config_db#(virtual apb_if18)::get(this, "", "vif18", vif18))
    `uvm_error("NOVIF18",{"virtual interface must be set for: ",get_full_name(),".vif18"})
  bus_collector18.item_collected_port18.connect(bus_monitor18.coll_mon_port18);
  bus_monitor18.addr_trans_port18.connect(bus_collector18.addr_trans_export18);
  master18.monitor18 = bus_monitor18;
  master18.collector18 = bus_collector18;
  foreach(slaves18[i]) begin
    slaves18[i].monitor18 = bus_monitor18;
    slaves18[i].collector18 = bus_collector18;
    if (slaves18[i].is_active == UVM_ACTIVE)
      slaves18[i].sequencer.addr_trans_port18.connect(bus_monitor18.addr_trans_export18);
  end
endfunction : connect_phase

// UVM start_of_simulation_phase
function void apb_env18::start_of_simulation_phase(uvm_phase phase);
  set_report_id_action_hier("CFGOVR18", UVM_DISPLAY);
  set_report_id_action_hier("CFGSET18", UVM_DISPLAY);
  check_config_usage();
endfunction : start_of_simulation_phase

// update_config18() method
function void apb_env18::update_config18(apb_config18 cfg);
  bus_monitor18.cfg = cfg;
  bus_collector18.cfg = cfg;
  master18.update_config18(cfg);
  foreach(slaves18[i])
    slaves18[i].update_config18(cfg.slave_configs18[i]);
endfunction : update_config18

// update_vif_enables18
task apb_env18::update_vif_enables18();
  vif18.has_checks18 <= checks_enable18;
  vif18.has_coverage <= coverage_enable18;
  forever begin
    @(checks_enable18 || coverage_enable18);
    vif18.has_checks18 <= checks_enable18;
    vif18.has_coverage <= coverage_enable18;
  end
endtask : update_vif_enables18

//UVM run_phase()
task apb_env18::run_phase(uvm_phase phase);
  fork
    update_vif_enables18();
  join
endtask : run_phase

`endif // APB_ENV_SV18
