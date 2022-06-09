/*******************************************************************************
  FILE : apb_env17.sv
*******************************************************************************/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------

`ifndef APB_ENV_SV17
`define APB_ENV_SV17

//------------------------------------------------------------------------------
// CLASS17: apb_env17
//------------------------------------------------------------------------------

class apb_env17 extends uvm_env;

  // Virtual interface for this environment17. This17 should only be done if the
  // same interface is used for all masters17/slaves17 in the environment17. Otherwise17,
  // Each agent17 should have its interface independently17 set.
  protected virtual interface apb_if17 vif17;

  // Environment17 Configuration17 Parameters17
  apb_config17 cfg;     // APB17 configuration object

  // The following17 two17 bits are used to control17 whether17 checks17 and coverage17 are
  // done both in the bus monitor17 class and the interface.
  bit checks_enable17 = 1; 
  bit coverage_enable17 = 1;

  // Components of the environment17
  apb_monitor17 bus_monitor17;
  apb_collector17 bus_collector17;
  apb_master_agent17 master17;
  apb_slave_agent17 slaves17[];

  // Provide17 implementations17 of virtual methods17 such17 as get_type_name and create
  `uvm_component_utils_begin(apb_env17)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable17, UVM_DEFAULT)
    `uvm_field_int(coverage_enable17, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor17 - Required17 UVM syntax17
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional17 class methods17
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual function void update_config17(apb_config17 cfg);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables17();

endclass : apb_env17

// UVM build_phase
function void apb_env17::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Create17 the APB17 UVC17 configuration class if it has not been set
  if(cfg == null) //begin
    if (!uvm_config_db#(apb_config17)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG17", "Using default_apb_config17", UVM_MEDIUM)
    $cast(cfg, factory.create_object_by_name("default_apb_config17","cfg"));
  end
  // set the master17 config
  uvm_config_object::set(this, "*", "cfg", cfg); 
  // set the slave17 configs17
  foreach(cfg.slave_configs17[i]) begin
    string sname;
    sname = $psprintf("slave17[%0d]*", i); 
    uvm_config_object::set(this, sname, "cfg", cfg.slave_configs17[i]);
  end

  bus_monitor17 = apb_monitor17::type_id::create("bus_monitor17",this);
  bus_collector17 = apb_collector17::type_id::create("bus_collector17",this);
  master17 = apb_master_agent17::type_id::create(cfg.master_config17.name,this);
  slaves17 = new[cfg.slave_configs17.size()];
  for(int i = 0; i < cfg.slave_configs17.size(); i++) begin
    slaves17[i] = apb_slave_agent17::type_id::create($psprintf("slave17[%0d]", i), this);
  end

endfunction : build_phase

// UVM connect_phase
function void apb_env17::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get17 the virtual interface if set via get_config
  if (!uvm_config_db#(virtual apb_if17)::get(this, "", "vif17", vif17))
    `uvm_error("NOVIF17",{"virtual interface must be set for: ",get_full_name(),".vif17"})
  bus_collector17.item_collected_port17.connect(bus_monitor17.coll_mon_port17);
  bus_monitor17.addr_trans_port17.connect(bus_collector17.addr_trans_export17);
  master17.monitor17 = bus_monitor17;
  master17.collector17 = bus_collector17;
  foreach(slaves17[i]) begin
    slaves17[i].monitor17 = bus_monitor17;
    slaves17[i].collector17 = bus_collector17;
    if (slaves17[i].is_active == UVM_ACTIVE)
      slaves17[i].sequencer.addr_trans_port17.connect(bus_monitor17.addr_trans_export17);
  end
endfunction : connect_phase

// UVM start_of_simulation_phase
function void apb_env17::start_of_simulation_phase(uvm_phase phase);
  set_report_id_action_hier("CFGOVR17", UVM_DISPLAY);
  set_report_id_action_hier("CFGSET17", UVM_DISPLAY);
  check_config_usage();
endfunction : start_of_simulation_phase

// update_config17() method
function void apb_env17::update_config17(apb_config17 cfg);
  bus_monitor17.cfg = cfg;
  bus_collector17.cfg = cfg;
  master17.update_config17(cfg);
  foreach(slaves17[i])
    slaves17[i].update_config17(cfg.slave_configs17[i]);
endfunction : update_config17

// update_vif_enables17
task apb_env17::update_vif_enables17();
  vif17.has_checks17 <= checks_enable17;
  vif17.has_coverage <= coverage_enable17;
  forever begin
    @(checks_enable17 || coverage_enable17);
    vif17.has_checks17 <= checks_enable17;
    vif17.has_coverage <= coverage_enable17;
  end
endtask : update_vif_enables17

//UVM run_phase()
task apb_env17::run_phase(uvm_phase phase);
  fork
    update_vif_enables17();
  join
endtask : run_phase

`endif // APB_ENV_SV17
