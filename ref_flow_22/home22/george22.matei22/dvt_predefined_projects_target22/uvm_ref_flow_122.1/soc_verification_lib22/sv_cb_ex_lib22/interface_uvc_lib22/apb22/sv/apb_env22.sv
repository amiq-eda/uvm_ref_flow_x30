/*******************************************************************************
  FILE : apb_env22.sv
*******************************************************************************/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------

`ifndef APB_ENV_SV22
`define APB_ENV_SV22

//------------------------------------------------------------------------------
// CLASS22: apb_env22
//------------------------------------------------------------------------------

class apb_env22 extends uvm_env;

  // Virtual interface for this environment22. This22 should only be done if the
  // same interface is used for all masters22/slaves22 in the environment22. Otherwise22,
  // Each agent22 should have its interface independently22 set.
  protected virtual interface apb_if22 vif22;

  // Environment22 Configuration22 Parameters22
  apb_config22 cfg;     // APB22 configuration object

  // The following22 two22 bits are used to control22 whether22 checks22 and coverage22 are
  // done both in the bus monitor22 class and the interface.
  bit checks_enable22 = 1; 
  bit coverage_enable22 = 1;

  // Components of the environment22
  apb_monitor22 bus_monitor22;
  apb_collector22 bus_collector22;
  apb_master_agent22 master22;
  apb_slave_agent22 slaves22[];

  // Provide22 implementations22 of virtual methods22 such22 as get_type_name and create
  `uvm_component_utils_begin(apb_env22)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable22, UVM_DEFAULT)
    `uvm_field_int(coverage_enable22, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor22 - Required22 UVM syntax22
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional22 class methods22
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual function void update_config22(apb_config22 cfg);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables22();

endclass : apb_env22

// UVM build_phase
function void apb_env22::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Create22 the APB22 UVC22 configuration class if it has not been set
  if(cfg == null) //begin
    if (!uvm_config_db#(apb_config22)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG22", "Using default_apb_config22", UVM_MEDIUM)
    $cast(cfg, factory.create_object_by_name("default_apb_config22","cfg"));
  end
  // set the master22 config
  uvm_config_object::set(this, "*", "cfg", cfg); 
  // set the slave22 configs22
  foreach(cfg.slave_configs22[i]) begin
    string sname;
    sname = $psprintf("slave22[%0d]*", i); 
    uvm_config_object::set(this, sname, "cfg", cfg.slave_configs22[i]);
  end

  bus_monitor22 = apb_monitor22::type_id::create("bus_monitor22",this);
  bus_collector22 = apb_collector22::type_id::create("bus_collector22",this);
  master22 = apb_master_agent22::type_id::create(cfg.master_config22.name,this);
  slaves22 = new[cfg.slave_configs22.size()];
  for(int i = 0; i < cfg.slave_configs22.size(); i++) begin
    slaves22[i] = apb_slave_agent22::type_id::create($psprintf("slave22[%0d]", i), this);
  end

endfunction : build_phase

// UVM connect_phase
function void apb_env22::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get22 the virtual interface if set via get_config
  if (!uvm_config_db#(virtual apb_if22)::get(this, "", "vif22", vif22))
    `uvm_error("NOVIF22",{"virtual interface must be set for: ",get_full_name(),".vif22"})
  bus_collector22.item_collected_port22.connect(bus_monitor22.coll_mon_port22);
  bus_monitor22.addr_trans_port22.connect(bus_collector22.addr_trans_export22);
  master22.monitor22 = bus_monitor22;
  master22.collector22 = bus_collector22;
  foreach(slaves22[i]) begin
    slaves22[i].monitor22 = bus_monitor22;
    slaves22[i].collector22 = bus_collector22;
    if (slaves22[i].is_active == UVM_ACTIVE)
      slaves22[i].sequencer.addr_trans_port22.connect(bus_monitor22.addr_trans_export22);
  end
endfunction : connect_phase

// UVM start_of_simulation_phase
function void apb_env22::start_of_simulation_phase(uvm_phase phase);
  set_report_id_action_hier("CFGOVR22", UVM_DISPLAY);
  set_report_id_action_hier("CFGSET22", UVM_DISPLAY);
  check_config_usage();
endfunction : start_of_simulation_phase

// update_config22() method
function void apb_env22::update_config22(apb_config22 cfg);
  bus_monitor22.cfg = cfg;
  bus_collector22.cfg = cfg;
  master22.update_config22(cfg);
  foreach(slaves22[i])
    slaves22[i].update_config22(cfg.slave_configs22[i]);
endfunction : update_config22

// update_vif_enables22
task apb_env22::update_vif_enables22();
  vif22.has_checks22 <= checks_enable22;
  vif22.has_coverage <= coverage_enable22;
  forever begin
    @(checks_enable22 || coverage_enable22);
    vif22.has_checks22 <= checks_enable22;
    vif22.has_coverage <= coverage_enable22;
  end
endtask : update_vif_enables22

//UVM run_phase()
task apb_env22::run_phase(uvm_phase phase);
  fork
    update_vif_enables22();
  join
endtask : run_phase

`endif // APB_ENV_SV22
