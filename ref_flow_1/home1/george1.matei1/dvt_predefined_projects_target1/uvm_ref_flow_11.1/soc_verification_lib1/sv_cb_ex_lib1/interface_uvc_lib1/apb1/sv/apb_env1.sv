/*******************************************************************************
  FILE : apb_env1.sv
*******************************************************************************/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------

`ifndef APB_ENV_SV1
`define APB_ENV_SV1

//------------------------------------------------------------------------------
// CLASS1: apb_env1
//------------------------------------------------------------------------------

class apb_env1 extends uvm_env;

  // Virtual interface for this environment1. This1 should only be done if the
  // same interface is used for all masters1/slaves1 in the environment1. Otherwise1,
  // Each agent1 should have its interface independently1 set.
  protected virtual interface apb_if1 vif1;

  // Environment1 Configuration1 Parameters1
  apb_config1 cfg;     // APB1 configuration object

  // The following1 two1 bits are used to control1 whether1 checks1 and coverage1 are
  // done both in the bus monitor1 class and the interface.
  bit checks_enable1 = 1; 
  bit coverage_enable1 = 1;

  // Components of the environment1
  apb_monitor1 bus_monitor1;
  apb_collector1 bus_collector1;
  apb_master_agent1 master1;
  apb_slave_agent1 slaves1[];

  // Provide1 implementations1 of virtual methods1 such1 as get_type_name and create
  `uvm_component_utils_begin(apb_env1)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable1, UVM_DEFAULT)
    `uvm_field_int(coverage_enable1, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor1 - Required1 UVM syntax1
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional1 class methods1
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual function void update_config1(apb_config1 cfg);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables1();

endclass : apb_env1

// UVM build_phase
function void apb_env1::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Create1 the APB1 UVC1 configuration class if it has not been set
  if(cfg == null) //begin
    if (!uvm_config_db#(apb_config1)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG1", "Using default_apb_config1", UVM_MEDIUM)
    $cast(cfg, factory.create_object_by_name("default_apb_config1","cfg"));
  end
  // set the master1 config
  uvm_config_object::set(this, "*", "cfg", cfg); 
  // set the slave1 configs1
  foreach(cfg.slave_configs1[i]) begin
    string sname;
    sname = $psprintf("slave1[%0d]*", i); 
    uvm_config_object::set(this, sname, "cfg", cfg.slave_configs1[i]);
  end

  bus_monitor1 = apb_monitor1::type_id::create("bus_monitor1",this);
  bus_collector1 = apb_collector1::type_id::create("bus_collector1",this);
  master1 = apb_master_agent1::type_id::create(cfg.master_config1.name,this);
  slaves1 = new[cfg.slave_configs1.size()];
  for(int i = 0; i < cfg.slave_configs1.size(); i++) begin
    slaves1[i] = apb_slave_agent1::type_id::create($psprintf("slave1[%0d]", i), this);
  end

endfunction : build_phase

// UVM connect_phase
function void apb_env1::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get1 the virtual interface if set via get_config
  if (!uvm_config_db#(virtual apb_if1)::get(this, "", "vif1", vif1))
    `uvm_error("NOVIF1",{"virtual interface must be set for: ",get_full_name(),".vif1"})
  bus_collector1.item_collected_port1.connect(bus_monitor1.coll_mon_port1);
  bus_monitor1.addr_trans_port1.connect(bus_collector1.addr_trans_export1);
  master1.monitor1 = bus_monitor1;
  master1.collector1 = bus_collector1;
  foreach(slaves1[i]) begin
    slaves1[i].monitor1 = bus_monitor1;
    slaves1[i].collector1 = bus_collector1;
    if (slaves1[i].is_active == UVM_ACTIVE)
      slaves1[i].sequencer.addr_trans_port1.connect(bus_monitor1.addr_trans_export1);
  end
endfunction : connect_phase

// UVM start_of_simulation_phase
function void apb_env1::start_of_simulation_phase(uvm_phase phase);
  set_report_id_action_hier("CFGOVR1", UVM_DISPLAY);
  set_report_id_action_hier("CFGSET1", UVM_DISPLAY);
  check_config_usage();
endfunction : start_of_simulation_phase

// update_config1() method
function void apb_env1::update_config1(apb_config1 cfg);
  bus_monitor1.cfg = cfg;
  bus_collector1.cfg = cfg;
  master1.update_config1(cfg);
  foreach(slaves1[i])
    slaves1[i].update_config1(cfg.slave_configs1[i]);
endfunction : update_config1

// update_vif_enables1
task apb_env1::update_vif_enables1();
  vif1.has_checks1 <= checks_enable1;
  vif1.has_coverage <= coverage_enable1;
  forever begin
    @(checks_enable1 || coverage_enable1);
    vif1.has_checks1 <= checks_enable1;
    vif1.has_coverage <= coverage_enable1;
  end
endtask : update_vif_enables1

//UVM run_phase()
task apb_env1::run_phase(uvm_phase phase);
  fork
    update_vif_enables1();
  join
endtask : run_phase

`endif // APB_ENV_SV1
