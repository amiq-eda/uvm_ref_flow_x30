/*******************************************************************************
  FILE : apb_env3.sv
*******************************************************************************/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------

`ifndef APB_ENV_SV3
`define APB_ENV_SV3

//------------------------------------------------------------------------------
// CLASS3: apb_env3
//------------------------------------------------------------------------------

class apb_env3 extends uvm_env;

  // Virtual interface for this environment3. This3 should only be done if the
  // same interface is used for all masters3/slaves3 in the environment3. Otherwise3,
  // Each agent3 should have its interface independently3 set.
  protected virtual interface apb_if3 vif3;

  // Environment3 Configuration3 Parameters3
  apb_config3 cfg;     // APB3 configuration object

  // The following3 two3 bits are used to control3 whether3 checks3 and coverage3 are
  // done both in the bus monitor3 class and the interface.
  bit checks_enable3 = 1; 
  bit coverage_enable3 = 1;

  // Components of the environment3
  apb_monitor3 bus_monitor3;
  apb_collector3 bus_collector3;
  apb_master_agent3 master3;
  apb_slave_agent3 slaves3[];

  // Provide3 implementations3 of virtual methods3 such3 as get_type_name and create
  `uvm_component_utils_begin(apb_env3)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable3, UVM_DEFAULT)
    `uvm_field_int(coverage_enable3, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor3 - Required3 UVM syntax3
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional3 class methods3
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual function void update_config3(apb_config3 cfg);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables3();

endclass : apb_env3

// UVM build_phase
function void apb_env3::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Create3 the APB3 UVC3 configuration class if it has not been set
  if(cfg == null) //begin
    if (!uvm_config_db#(apb_config3)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG3", "Using default_apb_config3", UVM_MEDIUM)
    $cast(cfg, factory.create_object_by_name("default_apb_config3","cfg"));
  end
  // set the master3 config
  uvm_config_object::set(this, "*", "cfg", cfg); 
  // set the slave3 configs3
  foreach(cfg.slave_configs3[i]) begin
    string sname;
    sname = $psprintf("slave3[%0d]*", i); 
    uvm_config_object::set(this, sname, "cfg", cfg.slave_configs3[i]);
  end

  bus_monitor3 = apb_monitor3::type_id::create("bus_monitor3",this);
  bus_collector3 = apb_collector3::type_id::create("bus_collector3",this);
  master3 = apb_master_agent3::type_id::create(cfg.master_config3.name,this);
  slaves3 = new[cfg.slave_configs3.size()];
  for(int i = 0; i < cfg.slave_configs3.size(); i++) begin
    slaves3[i] = apb_slave_agent3::type_id::create($psprintf("slave3[%0d]", i), this);
  end

endfunction : build_phase

// UVM connect_phase
function void apb_env3::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get3 the virtual interface if set via get_config
  if (!uvm_config_db#(virtual apb_if3)::get(this, "", "vif3", vif3))
    `uvm_error("NOVIF3",{"virtual interface must be set for: ",get_full_name(),".vif3"})
  bus_collector3.item_collected_port3.connect(bus_monitor3.coll_mon_port3);
  bus_monitor3.addr_trans_port3.connect(bus_collector3.addr_trans_export3);
  master3.monitor3 = bus_monitor3;
  master3.collector3 = bus_collector3;
  foreach(slaves3[i]) begin
    slaves3[i].monitor3 = bus_monitor3;
    slaves3[i].collector3 = bus_collector3;
    if (slaves3[i].is_active == UVM_ACTIVE)
      slaves3[i].sequencer.addr_trans_port3.connect(bus_monitor3.addr_trans_export3);
  end
endfunction : connect_phase

// UVM start_of_simulation_phase
function void apb_env3::start_of_simulation_phase(uvm_phase phase);
  set_report_id_action_hier("CFGOVR3", UVM_DISPLAY);
  set_report_id_action_hier("CFGSET3", UVM_DISPLAY);
  check_config_usage();
endfunction : start_of_simulation_phase

// update_config3() method
function void apb_env3::update_config3(apb_config3 cfg);
  bus_monitor3.cfg = cfg;
  bus_collector3.cfg = cfg;
  master3.update_config3(cfg);
  foreach(slaves3[i])
    slaves3[i].update_config3(cfg.slave_configs3[i]);
endfunction : update_config3

// update_vif_enables3
task apb_env3::update_vif_enables3();
  vif3.has_checks3 <= checks_enable3;
  vif3.has_coverage <= coverage_enable3;
  forever begin
    @(checks_enable3 || coverage_enable3);
    vif3.has_checks3 <= checks_enable3;
    vif3.has_coverage <= coverage_enable3;
  end
endtask : update_vif_enables3

//UVM run_phase()
task apb_env3::run_phase(uvm_phase phase);
  fork
    update_vif_enables3();
  join
endtask : run_phase

`endif // APB_ENV_SV3
