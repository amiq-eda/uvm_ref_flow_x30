/*******************************************************************************
  FILE : apb_env6.sv
*******************************************************************************/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------

`ifndef APB_ENV_SV6
`define APB_ENV_SV6

//------------------------------------------------------------------------------
// CLASS6: apb_env6
//------------------------------------------------------------------------------

class apb_env6 extends uvm_env;

  // Virtual interface for this environment6. This6 should only be done if the
  // same interface is used for all masters6/slaves6 in the environment6. Otherwise6,
  // Each agent6 should have its interface independently6 set.
  protected virtual interface apb_if6 vif6;

  // Environment6 Configuration6 Parameters6
  apb_config6 cfg;     // APB6 configuration object

  // The following6 two6 bits are used to control6 whether6 checks6 and coverage6 are
  // done both in the bus monitor6 class and the interface.
  bit checks_enable6 = 1; 
  bit coverage_enable6 = 1;

  // Components of the environment6
  apb_monitor6 bus_monitor6;
  apb_collector6 bus_collector6;
  apb_master_agent6 master6;
  apb_slave_agent6 slaves6[];

  // Provide6 implementations6 of virtual methods6 such6 as get_type_name and create
  `uvm_component_utils_begin(apb_env6)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable6, UVM_DEFAULT)
    `uvm_field_int(coverage_enable6, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor6 - Required6 UVM syntax6
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional6 class methods6
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual function void update_config6(apb_config6 cfg);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables6();

endclass : apb_env6

// UVM build_phase
function void apb_env6::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Create6 the APB6 UVC6 configuration class if it has not been set
  if(cfg == null) //begin
    if (!uvm_config_db#(apb_config6)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG6", "Using default_apb_config6", UVM_MEDIUM)
    $cast(cfg, factory.create_object_by_name("default_apb_config6","cfg"));
  end
  // set the master6 config
  uvm_config_object::set(this, "*", "cfg", cfg); 
  // set the slave6 configs6
  foreach(cfg.slave_configs6[i]) begin
    string sname;
    sname = $psprintf("slave6[%0d]*", i); 
    uvm_config_object::set(this, sname, "cfg", cfg.slave_configs6[i]);
  end

  bus_monitor6 = apb_monitor6::type_id::create("bus_monitor6",this);
  bus_collector6 = apb_collector6::type_id::create("bus_collector6",this);
  master6 = apb_master_agent6::type_id::create(cfg.master_config6.name,this);
  slaves6 = new[cfg.slave_configs6.size()];
  for(int i = 0; i < cfg.slave_configs6.size(); i++) begin
    slaves6[i] = apb_slave_agent6::type_id::create($psprintf("slave6[%0d]", i), this);
  end

endfunction : build_phase

// UVM connect_phase
function void apb_env6::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get6 the virtual interface if set via get_config
  if (!uvm_config_db#(virtual apb_if6)::get(this, "", "vif6", vif6))
    `uvm_error("NOVIF6",{"virtual interface must be set for: ",get_full_name(),".vif6"})
  bus_collector6.item_collected_port6.connect(bus_monitor6.coll_mon_port6);
  bus_monitor6.addr_trans_port6.connect(bus_collector6.addr_trans_export6);
  master6.monitor6 = bus_monitor6;
  master6.collector6 = bus_collector6;
  foreach(slaves6[i]) begin
    slaves6[i].monitor6 = bus_monitor6;
    slaves6[i].collector6 = bus_collector6;
    if (slaves6[i].is_active == UVM_ACTIVE)
      slaves6[i].sequencer.addr_trans_port6.connect(bus_monitor6.addr_trans_export6);
  end
endfunction : connect_phase

// UVM start_of_simulation_phase
function void apb_env6::start_of_simulation_phase(uvm_phase phase);
  set_report_id_action_hier("CFGOVR6", UVM_DISPLAY);
  set_report_id_action_hier("CFGSET6", UVM_DISPLAY);
  check_config_usage();
endfunction : start_of_simulation_phase

// update_config6() method
function void apb_env6::update_config6(apb_config6 cfg);
  bus_monitor6.cfg = cfg;
  bus_collector6.cfg = cfg;
  master6.update_config6(cfg);
  foreach(slaves6[i])
    slaves6[i].update_config6(cfg.slave_configs6[i]);
endfunction : update_config6

// update_vif_enables6
task apb_env6::update_vif_enables6();
  vif6.has_checks6 <= checks_enable6;
  vif6.has_coverage <= coverage_enable6;
  forever begin
    @(checks_enable6 || coverage_enable6);
    vif6.has_checks6 <= checks_enable6;
    vif6.has_coverage <= coverage_enable6;
  end
endtask : update_vif_enables6

//UVM run_phase()
task apb_env6::run_phase(uvm_phase phase);
  fork
    update_vif_enables6();
  join
endtask : run_phase

`endif // APB_ENV_SV6
