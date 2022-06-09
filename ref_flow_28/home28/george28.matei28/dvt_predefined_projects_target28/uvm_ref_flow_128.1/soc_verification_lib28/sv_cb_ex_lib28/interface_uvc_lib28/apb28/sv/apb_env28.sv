/*******************************************************************************
  FILE : apb_env28.sv
*******************************************************************************/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------

`ifndef APB_ENV_SV28
`define APB_ENV_SV28

//------------------------------------------------------------------------------
// CLASS28: apb_env28
//------------------------------------------------------------------------------

class apb_env28 extends uvm_env;

  // Virtual interface for this environment28. This28 should only be done if the
  // same interface is used for all masters28/slaves28 in the environment28. Otherwise28,
  // Each agent28 should have its interface independently28 set.
  protected virtual interface apb_if28 vif28;

  // Environment28 Configuration28 Parameters28
  apb_config28 cfg;     // APB28 configuration object

  // The following28 two28 bits are used to control28 whether28 checks28 and coverage28 are
  // done both in the bus monitor28 class and the interface.
  bit checks_enable28 = 1; 
  bit coverage_enable28 = 1;

  // Components of the environment28
  apb_monitor28 bus_monitor28;
  apb_collector28 bus_collector28;
  apb_master_agent28 master28;
  apb_slave_agent28 slaves28[];

  // Provide28 implementations28 of virtual methods28 such28 as get_type_name and create
  `uvm_component_utils_begin(apb_env28)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable28, UVM_DEFAULT)
    `uvm_field_int(coverage_enable28, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor28 - Required28 UVM syntax28
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional28 class methods28
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual function void update_config28(apb_config28 cfg);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables28();

endclass : apb_env28

// UVM build_phase
function void apb_env28::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Create28 the APB28 UVC28 configuration class if it has not been set
  if(cfg == null) //begin
    if (!uvm_config_db#(apb_config28)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG28", "Using default_apb_config28", UVM_MEDIUM)
    $cast(cfg, factory.create_object_by_name("default_apb_config28","cfg"));
  end
  // set the master28 config
  uvm_config_object::set(this, "*", "cfg", cfg); 
  // set the slave28 configs28
  foreach(cfg.slave_configs28[i]) begin
    string sname;
    sname = $psprintf("slave28[%0d]*", i); 
    uvm_config_object::set(this, sname, "cfg", cfg.slave_configs28[i]);
  end

  bus_monitor28 = apb_monitor28::type_id::create("bus_monitor28",this);
  bus_collector28 = apb_collector28::type_id::create("bus_collector28",this);
  master28 = apb_master_agent28::type_id::create(cfg.master_config28.name,this);
  slaves28 = new[cfg.slave_configs28.size()];
  for(int i = 0; i < cfg.slave_configs28.size(); i++) begin
    slaves28[i] = apb_slave_agent28::type_id::create($psprintf("slave28[%0d]", i), this);
  end

endfunction : build_phase

// UVM connect_phase
function void apb_env28::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get28 the virtual interface if set via get_config
  if (!uvm_config_db#(virtual apb_if28)::get(this, "", "vif28", vif28))
    `uvm_error("NOVIF28",{"virtual interface must be set for: ",get_full_name(),".vif28"})
  bus_collector28.item_collected_port28.connect(bus_monitor28.coll_mon_port28);
  bus_monitor28.addr_trans_port28.connect(bus_collector28.addr_trans_export28);
  master28.monitor28 = bus_monitor28;
  master28.collector28 = bus_collector28;
  foreach(slaves28[i]) begin
    slaves28[i].monitor28 = bus_monitor28;
    slaves28[i].collector28 = bus_collector28;
    if (slaves28[i].is_active == UVM_ACTIVE)
      slaves28[i].sequencer.addr_trans_port28.connect(bus_monitor28.addr_trans_export28);
  end
endfunction : connect_phase

// UVM start_of_simulation_phase
function void apb_env28::start_of_simulation_phase(uvm_phase phase);
  set_report_id_action_hier("CFGOVR28", UVM_DISPLAY);
  set_report_id_action_hier("CFGSET28", UVM_DISPLAY);
  check_config_usage();
endfunction : start_of_simulation_phase

// update_config28() method
function void apb_env28::update_config28(apb_config28 cfg);
  bus_monitor28.cfg = cfg;
  bus_collector28.cfg = cfg;
  master28.update_config28(cfg);
  foreach(slaves28[i])
    slaves28[i].update_config28(cfg.slave_configs28[i]);
endfunction : update_config28

// update_vif_enables28
task apb_env28::update_vif_enables28();
  vif28.has_checks28 <= checks_enable28;
  vif28.has_coverage <= coverage_enable28;
  forever begin
    @(checks_enable28 || coverage_enable28);
    vif28.has_checks28 <= checks_enable28;
    vif28.has_coverage <= coverage_enable28;
  end
endtask : update_vif_enables28

//UVM run_phase()
task apb_env28::run_phase(uvm_phase phase);
  fork
    update_vif_enables28();
  join
endtask : run_phase

`endif // APB_ENV_SV28
