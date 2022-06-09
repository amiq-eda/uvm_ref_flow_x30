/*******************************************************************************
  FILE : apb_env27.sv
*******************************************************************************/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------

`ifndef APB_ENV_SV27
`define APB_ENV_SV27

//------------------------------------------------------------------------------
// CLASS27: apb_env27
//------------------------------------------------------------------------------

class apb_env27 extends uvm_env;

  // Virtual interface for this environment27. This27 should only be done if the
  // same interface is used for all masters27/slaves27 in the environment27. Otherwise27,
  // Each agent27 should have its interface independently27 set.
  protected virtual interface apb_if27 vif27;

  // Environment27 Configuration27 Parameters27
  apb_config27 cfg;     // APB27 configuration object

  // The following27 two27 bits are used to control27 whether27 checks27 and coverage27 are
  // done both in the bus monitor27 class and the interface.
  bit checks_enable27 = 1; 
  bit coverage_enable27 = 1;

  // Components of the environment27
  apb_monitor27 bus_monitor27;
  apb_collector27 bus_collector27;
  apb_master_agent27 master27;
  apb_slave_agent27 slaves27[];

  // Provide27 implementations27 of virtual methods27 such27 as get_type_name and create
  `uvm_component_utils_begin(apb_env27)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable27, UVM_DEFAULT)
    `uvm_field_int(coverage_enable27, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor27 - Required27 UVM syntax27
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional27 class methods27
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual function void update_config27(apb_config27 cfg);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables27();

endclass : apb_env27

// UVM build_phase
function void apb_env27::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Create27 the APB27 UVC27 configuration class if it has not been set
  if(cfg == null) //begin
    if (!uvm_config_db#(apb_config27)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG27", "Using default_apb_config27", UVM_MEDIUM)
    $cast(cfg, factory.create_object_by_name("default_apb_config27","cfg"));
  end
  // set the master27 config
  uvm_config_object::set(this, "*", "cfg", cfg); 
  // set the slave27 configs27
  foreach(cfg.slave_configs27[i]) begin
    string sname;
    sname = $psprintf("slave27[%0d]*", i); 
    uvm_config_object::set(this, sname, "cfg", cfg.slave_configs27[i]);
  end

  bus_monitor27 = apb_monitor27::type_id::create("bus_monitor27",this);
  bus_collector27 = apb_collector27::type_id::create("bus_collector27",this);
  master27 = apb_master_agent27::type_id::create(cfg.master_config27.name,this);
  slaves27 = new[cfg.slave_configs27.size()];
  for(int i = 0; i < cfg.slave_configs27.size(); i++) begin
    slaves27[i] = apb_slave_agent27::type_id::create($psprintf("slave27[%0d]", i), this);
  end

endfunction : build_phase

// UVM connect_phase
function void apb_env27::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get27 the virtual interface if set via get_config
  if (!uvm_config_db#(virtual apb_if27)::get(this, "", "vif27", vif27))
    `uvm_error("NOVIF27",{"virtual interface must be set for: ",get_full_name(),".vif27"})
  bus_collector27.item_collected_port27.connect(bus_monitor27.coll_mon_port27);
  bus_monitor27.addr_trans_port27.connect(bus_collector27.addr_trans_export27);
  master27.monitor27 = bus_monitor27;
  master27.collector27 = bus_collector27;
  foreach(slaves27[i]) begin
    slaves27[i].monitor27 = bus_monitor27;
    slaves27[i].collector27 = bus_collector27;
    if (slaves27[i].is_active == UVM_ACTIVE)
      slaves27[i].sequencer.addr_trans_port27.connect(bus_monitor27.addr_trans_export27);
  end
endfunction : connect_phase

// UVM start_of_simulation_phase
function void apb_env27::start_of_simulation_phase(uvm_phase phase);
  set_report_id_action_hier("CFGOVR27", UVM_DISPLAY);
  set_report_id_action_hier("CFGSET27", UVM_DISPLAY);
  check_config_usage();
endfunction : start_of_simulation_phase

// update_config27() method
function void apb_env27::update_config27(apb_config27 cfg);
  bus_monitor27.cfg = cfg;
  bus_collector27.cfg = cfg;
  master27.update_config27(cfg);
  foreach(slaves27[i])
    slaves27[i].update_config27(cfg.slave_configs27[i]);
endfunction : update_config27

// update_vif_enables27
task apb_env27::update_vif_enables27();
  vif27.has_checks27 <= checks_enable27;
  vif27.has_coverage <= coverage_enable27;
  forever begin
    @(checks_enable27 || coverage_enable27);
    vif27.has_checks27 <= checks_enable27;
    vif27.has_coverage <= coverage_enable27;
  end
endtask : update_vif_enables27

//UVM run_phase()
task apb_env27::run_phase(uvm_phase phase);
  fork
    update_vif_enables27();
  join
endtask : run_phase

`endif // APB_ENV_SV27
