/*******************************************************************************
  FILE : apb_env26.sv
*******************************************************************************/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------

`ifndef APB_ENV_SV26
`define APB_ENV_SV26

//------------------------------------------------------------------------------
// CLASS26: apb_env26
//------------------------------------------------------------------------------

class apb_env26 extends uvm_env;

  // Virtual interface for this environment26. This26 should only be done if the
  // same interface is used for all masters26/slaves26 in the environment26. Otherwise26,
  // Each agent26 should have its interface independently26 set.
  protected virtual interface apb_if26 vif26;

  // Environment26 Configuration26 Parameters26
  apb_config26 cfg;     // APB26 configuration object

  // The following26 two26 bits are used to control26 whether26 checks26 and coverage26 are
  // done both in the bus monitor26 class and the interface.
  bit checks_enable26 = 1; 
  bit coverage_enable26 = 1;

  // Components of the environment26
  apb_monitor26 bus_monitor26;
  apb_collector26 bus_collector26;
  apb_master_agent26 master26;
  apb_slave_agent26 slaves26[];

  // Provide26 implementations26 of virtual methods26 such26 as get_type_name and create
  `uvm_component_utils_begin(apb_env26)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable26, UVM_DEFAULT)
    `uvm_field_int(coverage_enable26, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor26 - Required26 UVM syntax26
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional26 class methods26
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual function void update_config26(apb_config26 cfg);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables26();

endclass : apb_env26

// UVM build_phase
function void apb_env26::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Create26 the APB26 UVC26 configuration class if it has not been set
  if(cfg == null) //begin
    if (!uvm_config_db#(apb_config26)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG26", "Using default_apb_config26", UVM_MEDIUM)
    $cast(cfg, factory.create_object_by_name("default_apb_config26","cfg"));
  end
  // set the master26 config
  uvm_config_object::set(this, "*", "cfg", cfg); 
  // set the slave26 configs26
  foreach(cfg.slave_configs26[i]) begin
    string sname;
    sname = $psprintf("slave26[%0d]*", i); 
    uvm_config_object::set(this, sname, "cfg", cfg.slave_configs26[i]);
  end

  bus_monitor26 = apb_monitor26::type_id::create("bus_monitor26",this);
  bus_collector26 = apb_collector26::type_id::create("bus_collector26",this);
  master26 = apb_master_agent26::type_id::create(cfg.master_config26.name,this);
  slaves26 = new[cfg.slave_configs26.size()];
  for(int i = 0; i < cfg.slave_configs26.size(); i++) begin
    slaves26[i] = apb_slave_agent26::type_id::create($psprintf("slave26[%0d]", i), this);
  end

endfunction : build_phase

// UVM connect_phase
function void apb_env26::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get26 the virtual interface if set via get_config
  if (!uvm_config_db#(virtual apb_if26)::get(this, "", "vif26", vif26))
    `uvm_error("NOVIF26",{"virtual interface must be set for: ",get_full_name(),".vif26"})
  bus_collector26.item_collected_port26.connect(bus_monitor26.coll_mon_port26);
  bus_monitor26.addr_trans_port26.connect(bus_collector26.addr_trans_export26);
  master26.monitor26 = bus_monitor26;
  master26.collector26 = bus_collector26;
  foreach(slaves26[i]) begin
    slaves26[i].monitor26 = bus_monitor26;
    slaves26[i].collector26 = bus_collector26;
    if (slaves26[i].is_active == UVM_ACTIVE)
      slaves26[i].sequencer.addr_trans_port26.connect(bus_monitor26.addr_trans_export26);
  end
endfunction : connect_phase

// UVM start_of_simulation_phase
function void apb_env26::start_of_simulation_phase(uvm_phase phase);
  set_report_id_action_hier("CFGOVR26", UVM_DISPLAY);
  set_report_id_action_hier("CFGSET26", UVM_DISPLAY);
  check_config_usage();
endfunction : start_of_simulation_phase

// update_config26() method
function void apb_env26::update_config26(apb_config26 cfg);
  bus_monitor26.cfg = cfg;
  bus_collector26.cfg = cfg;
  master26.update_config26(cfg);
  foreach(slaves26[i])
    slaves26[i].update_config26(cfg.slave_configs26[i]);
endfunction : update_config26

// update_vif_enables26
task apb_env26::update_vif_enables26();
  vif26.has_checks26 <= checks_enable26;
  vif26.has_coverage <= coverage_enable26;
  forever begin
    @(checks_enable26 || coverage_enable26);
    vif26.has_checks26 <= checks_enable26;
    vif26.has_coverage <= coverage_enable26;
  end
endtask : update_vif_enables26

//UVM run_phase()
task apb_env26::run_phase(uvm_phase phase);
  fork
    update_vif_enables26();
  join
endtask : run_phase

`endif // APB_ENV_SV26
