/*******************************************************************************
  FILE : apb_env29.sv
*******************************************************************************/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------

`ifndef APB_ENV_SV29
`define APB_ENV_SV29

//------------------------------------------------------------------------------
// CLASS29: apb_env29
//------------------------------------------------------------------------------

class apb_env29 extends uvm_env;

  // Virtual interface for this environment29. This29 should only be done if the
  // same interface is used for all masters29/slaves29 in the environment29. Otherwise29,
  // Each agent29 should have its interface independently29 set.
  protected virtual interface apb_if29 vif29;

  // Environment29 Configuration29 Parameters29
  apb_config29 cfg;     // APB29 configuration object

  // The following29 two29 bits are used to control29 whether29 checks29 and coverage29 are
  // done both in the bus monitor29 class and the interface.
  bit checks_enable29 = 1; 
  bit coverage_enable29 = 1;

  // Components of the environment29
  apb_monitor29 bus_monitor29;
  apb_collector29 bus_collector29;
  apb_master_agent29 master29;
  apb_slave_agent29 slaves29[];

  // Provide29 implementations29 of virtual methods29 such29 as get_type_name and create
  `uvm_component_utils_begin(apb_env29)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable29, UVM_DEFAULT)
    `uvm_field_int(coverage_enable29, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor29 - Required29 UVM syntax29
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional29 class methods29
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual function void update_config29(apb_config29 cfg);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables29();

endclass : apb_env29

// UVM build_phase
function void apb_env29::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Create29 the APB29 UVC29 configuration class if it has not been set
  if(cfg == null) //begin
    if (!uvm_config_db#(apb_config29)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG29", "Using default_apb_config29", UVM_MEDIUM)
    $cast(cfg, factory.create_object_by_name("default_apb_config29","cfg"));
  end
  // set the master29 config
  uvm_config_object::set(this, "*", "cfg", cfg); 
  // set the slave29 configs29
  foreach(cfg.slave_configs29[i]) begin
    string sname;
    sname = $psprintf("slave29[%0d]*", i); 
    uvm_config_object::set(this, sname, "cfg", cfg.slave_configs29[i]);
  end

  bus_monitor29 = apb_monitor29::type_id::create("bus_monitor29",this);
  bus_collector29 = apb_collector29::type_id::create("bus_collector29",this);
  master29 = apb_master_agent29::type_id::create(cfg.master_config29.name,this);
  slaves29 = new[cfg.slave_configs29.size()];
  for(int i = 0; i < cfg.slave_configs29.size(); i++) begin
    slaves29[i] = apb_slave_agent29::type_id::create($psprintf("slave29[%0d]", i), this);
  end

endfunction : build_phase

// UVM connect_phase
function void apb_env29::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get29 the virtual interface if set via get_config
  if (!uvm_config_db#(virtual apb_if29)::get(this, "", "vif29", vif29))
    `uvm_error("NOVIF29",{"virtual interface must be set for: ",get_full_name(),".vif29"})
  bus_collector29.item_collected_port29.connect(bus_monitor29.coll_mon_port29);
  bus_monitor29.addr_trans_port29.connect(bus_collector29.addr_trans_export29);
  master29.monitor29 = bus_monitor29;
  master29.collector29 = bus_collector29;
  foreach(slaves29[i]) begin
    slaves29[i].monitor29 = bus_monitor29;
    slaves29[i].collector29 = bus_collector29;
    if (slaves29[i].is_active == UVM_ACTIVE)
      slaves29[i].sequencer.addr_trans_port29.connect(bus_monitor29.addr_trans_export29);
  end
endfunction : connect_phase

// UVM start_of_simulation_phase
function void apb_env29::start_of_simulation_phase(uvm_phase phase);
  set_report_id_action_hier("CFGOVR29", UVM_DISPLAY);
  set_report_id_action_hier("CFGSET29", UVM_DISPLAY);
  check_config_usage();
endfunction : start_of_simulation_phase

// update_config29() method
function void apb_env29::update_config29(apb_config29 cfg);
  bus_monitor29.cfg = cfg;
  bus_collector29.cfg = cfg;
  master29.update_config29(cfg);
  foreach(slaves29[i])
    slaves29[i].update_config29(cfg.slave_configs29[i]);
endfunction : update_config29

// update_vif_enables29
task apb_env29::update_vif_enables29();
  vif29.has_checks29 <= checks_enable29;
  vif29.has_coverage <= coverage_enable29;
  forever begin
    @(checks_enable29 || coverage_enable29);
    vif29.has_checks29 <= checks_enable29;
    vif29.has_coverage <= coverage_enable29;
  end
endtask : update_vif_enables29

//UVM run_phase()
task apb_env29::run_phase(uvm_phase phase);
  fork
    update_vif_enables29();
  join
endtask : run_phase

`endif // APB_ENV_SV29
