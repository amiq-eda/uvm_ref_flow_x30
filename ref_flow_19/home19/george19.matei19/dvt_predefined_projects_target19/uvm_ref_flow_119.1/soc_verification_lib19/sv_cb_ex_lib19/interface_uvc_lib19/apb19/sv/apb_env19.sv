/*******************************************************************************
  FILE : apb_env19.sv
*******************************************************************************/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------

`ifndef APB_ENV_SV19
`define APB_ENV_SV19

//------------------------------------------------------------------------------
// CLASS19: apb_env19
//------------------------------------------------------------------------------

class apb_env19 extends uvm_env;

  // Virtual interface for this environment19. This19 should only be done if the
  // same interface is used for all masters19/slaves19 in the environment19. Otherwise19,
  // Each agent19 should have its interface independently19 set.
  protected virtual interface apb_if19 vif19;

  // Environment19 Configuration19 Parameters19
  apb_config19 cfg;     // APB19 configuration object

  // The following19 two19 bits are used to control19 whether19 checks19 and coverage19 are
  // done both in the bus monitor19 class and the interface.
  bit checks_enable19 = 1; 
  bit coverage_enable19 = 1;

  // Components of the environment19
  apb_monitor19 bus_monitor19;
  apb_collector19 bus_collector19;
  apb_master_agent19 master19;
  apb_slave_agent19 slaves19[];

  // Provide19 implementations19 of virtual methods19 such19 as get_type_name and create
  `uvm_component_utils_begin(apb_env19)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable19, UVM_DEFAULT)
    `uvm_field_int(coverage_enable19, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor19 - Required19 UVM syntax19
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional19 class methods19
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual function void update_config19(apb_config19 cfg);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables19();

endclass : apb_env19

// UVM build_phase
function void apb_env19::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Create19 the APB19 UVC19 configuration class if it has not been set
  if(cfg == null) //begin
    if (!uvm_config_db#(apb_config19)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG19", "Using default_apb_config19", UVM_MEDIUM)
    $cast(cfg, factory.create_object_by_name("default_apb_config19","cfg"));
  end
  // set the master19 config
  uvm_config_object::set(this, "*", "cfg", cfg); 
  // set the slave19 configs19
  foreach(cfg.slave_configs19[i]) begin
    string sname;
    sname = $psprintf("slave19[%0d]*", i); 
    uvm_config_object::set(this, sname, "cfg", cfg.slave_configs19[i]);
  end

  bus_monitor19 = apb_monitor19::type_id::create("bus_monitor19",this);
  bus_collector19 = apb_collector19::type_id::create("bus_collector19",this);
  master19 = apb_master_agent19::type_id::create(cfg.master_config19.name,this);
  slaves19 = new[cfg.slave_configs19.size()];
  for(int i = 0; i < cfg.slave_configs19.size(); i++) begin
    slaves19[i] = apb_slave_agent19::type_id::create($psprintf("slave19[%0d]", i), this);
  end

endfunction : build_phase

// UVM connect_phase
function void apb_env19::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get19 the virtual interface if set via get_config
  if (!uvm_config_db#(virtual apb_if19)::get(this, "", "vif19", vif19))
    `uvm_error("NOVIF19",{"virtual interface must be set for: ",get_full_name(),".vif19"})
  bus_collector19.item_collected_port19.connect(bus_monitor19.coll_mon_port19);
  bus_monitor19.addr_trans_port19.connect(bus_collector19.addr_trans_export19);
  master19.monitor19 = bus_monitor19;
  master19.collector19 = bus_collector19;
  foreach(slaves19[i]) begin
    slaves19[i].monitor19 = bus_monitor19;
    slaves19[i].collector19 = bus_collector19;
    if (slaves19[i].is_active == UVM_ACTIVE)
      slaves19[i].sequencer.addr_trans_port19.connect(bus_monitor19.addr_trans_export19);
  end
endfunction : connect_phase

// UVM start_of_simulation_phase
function void apb_env19::start_of_simulation_phase(uvm_phase phase);
  set_report_id_action_hier("CFGOVR19", UVM_DISPLAY);
  set_report_id_action_hier("CFGSET19", UVM_DISPLAY);
  check_config_usage();
endfunction : start_of_simulation_phase

// update_config19() method
function void apb_env19::update_config19(apb_config19 cfg);
  bus_monitor19.cfg = cfg;
  bus_collector19.cfg = cfg;
  master19.update_config19(cfg);
  foreach(slaves19[i])
    slaves19[i].update_config19(cfg.slave_configs19[i]);
endfunction : update_config19

// update_vif_enables19
task apb_env19::update_vif_enables19();
  vif19.has_checks19 <= checks_enable19;
  vif19.has_coverage <= coverage_enable19;
  forever begin
    @(checks_enable19 || coverage_enable19);
    vif19.has_checks19 <= checks_enable19;
    vif19.has_coverage <= coverage_enable19;
  end
endtask : update_vif_enables19

//UVM run_phase()
task apb_env19::run_phase(uvm_phase phase);
  fork
    update_vif_enables19();
  join
endtask : run_phase

`endif // APB_ENV_SV19
