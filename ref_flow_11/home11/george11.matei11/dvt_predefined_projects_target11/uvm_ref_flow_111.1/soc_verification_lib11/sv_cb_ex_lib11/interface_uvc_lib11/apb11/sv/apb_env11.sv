/*******************************************************************************
  FILE : apb_env11.sv
*******************************************************************************/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------

`ifndef APB_ENV_SV11
`define APB_ENV_SV11

//------------------------------------------------------------------------------
// CLASS11: apb_env11
//------------------------------------------------------------------------------

class apb_env11 extends uvm_env;

  // Virtual interface for this environment11. This11 should only be done if the
  // same interface is used for all masters11/slaves11 in the environment11. Otherwise11,
  // Each agent11 should have its interface independently11 set.
  protected virtual interface apb_if11 vif11;

  // Environment11 Configuration11 Parameters11
  apb_config11 cfg;     // APB11 configuration object

  // The following11 two11 bits are used to control11 whether11 checks11 and coverage11 are
  // done both in the bus monitor11 class and the interface.
  bit checks_enable11 = 1; 
  bit coverage_enable11 = 1;

  // Components of the environment11
  apb_monitor11 bus_monitor11;
  apb_collector11 bus_collector11;
  apb_master_agent11 master11;
  apb_slave_agent11 slaves11[];

  // Provide11 implementations11 of virtual methods11 such11 as get_type_name and create
  `uvm_component_utils_begin(apb_env11)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable11, UVM_DEFAULT)
    `uvm_field_int(coverage_enable11, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor11 - Required11 UVM syntax11
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional11 class methods11
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual function void update_config11(apb_config11 cfg);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables11();

endclass : apb_env11

// UVM build_phase
function void apb_env11::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Create11 the APB11 UVC11 configuration class if it has not been set
  if(cfg == null) //begin
    if (!uvm_config_db#(apb_config11)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG11", "Using default_apb_config11", UVM_MEDIUM)
    $cast(cfg, factory.create_object_by_name("default_apb_config11","cfg"));
  end
  // set the master11 config
  uvm_config_object::set(this, "*", "cfg", cfg); 
  // set the slave11 configs11
  foreach(cfg.slave_configs11[i]) begin
    string sname;
    sname = $psprintf("slave11[%0d]*", i); 
    uvm_config_object::set(this, sname, "cfg", cfg.slave_configs11[i]);
  end

  bus_monitor11 = apb_monitor11::type_id::create("bus_monitor11",this);
  bus_collector11 = apb_collector11::type_id::create("bus_collector11",this);
  master11 = apb_master_agent11::type_id::create(cfg.master_config11.name,this);
  slaves11 = new[cfg.slave_configs11.size()];
  for(int i = 0; i < cfg.slave_configs11.size(); i++) begin
    slaves11[i] = apb_slave_agent11::type_id::create($psprintf("slave11[%0d]", i), this);
  end

endfunction : build_phase

// UVM connect_phase
function void apb_env11::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get11 the virtual interface if set via get_config
  if (!uvm_config_db#(virtual apb_if11)::get(this, "", "vif11", vif11))
    `uvm_error("NOVIF11",{"virtual interface must be set for: ",get_full_name(),".vif11"})
  bus_collector11.item_collected_port11.connect(bus_monitor11.coll_mon_port11);
  bus_monitor11.addr_trans_port11.connect(bus_collector11.addr_trans_export11);
  master11.monitor11 = bus_monitor11;
  master11.collector11 = bus_collector11;
  foreach(slaves11[i]) begin
    slaves11[i].monitor11 = bus_monitor11;
    slaves11[i].collector11 = bus_collector11;
    if (slaves11[i].is_active == UVM_ACTIVE)
      slaves11[i].sequencer.addr_trans_port11.connect(bus_monitor11.addr_trans_export11);
  end
endfunction : connect_phase

// UVM start_of_simulation_phase
function void apb_env11::start_of_simulation_phase(uvm_phase phase);
  set_report_id_action_hier("CFGOVR11", UVM_DISPLAY);
  set_report_id_action_hier("CFGSET11", UVM_DISPLAY);
  check_config_usage();
endfunction : start_of_simulation_phase

// update_config11() method
function void apb_env11::update_config11(apb_config11 cfg);
  bus_monitor11.cfg = cfg;
  bus_collector11.cfg = cfg;
  master11.update_config11(cfg);
  foreach(slaves11[i])
    slaves11[i].update_config11(cfg.slave_configs11[i]);
endfunction : update_config11

// update_vif_enables11
task apb_env11::update_vif_enables11();
  vif11.has_checks11 <= checks_enable11;
  vif11.has_coverage <= coverage_enable11;
  forever begin
    @(checks_enable11 || coverage_enable11);
    vif11.has_checks11 <= checks_enable11;
    vif11.has_coverage <= coverage_enable11;
  end
endtask : update_vif_enables11

//UVM run_phase()
task apb_env11::run_phase(uvm_phase phase);
  fork
    update_vif_enables11();
  join
endtask : run_phase

`endif // APB_ENV_SV11
