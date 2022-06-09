/*******************************************************************************
  FILE : apb_env23.sv
*******************************************************************************/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------

`ifndef APB_ENV_SV23
`define APB_ENV_SV23

//------------------------------------------------------------------------------
// CLASS23: apb_env23
//------------------------------------------------------------------------------

class apb_env23 extends uvm_env;

  // Virtual interface for this environment23. This23 should only be done if the
  // same interface is used for all masters23/slaves23 in the environment23. Otherwise23,
  // Each agent23 should have its interface independently23 set.
  protected virtual interface apb_if23 vif23;

  // Environment23 Configuration23 Parameters23
  apb_config23 cfg;     // APB23 configuration object

  // The following23 two23 bits are used to control23 whether23 checks23 and coverage23 are
  // done both in the bus monitor23 class and the interface.
  bit checks_enable23 = 1; 
  bit coverage_enable23 = 1;

  // Components of the environment23
  apb_monitor23 bus_monitor23;
  apb_collector23 bus_collector23;
  apb_master_agent23 master23;
  apb_slave_agent23 slaves23[];

  // Provide23 implementations23 of virtual methods23 such23 as get_type_name and create
  `uvm_component_utils_begin(apb_env23)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable23, UVM_DEFAULT)
    `uvm_field_int(coverage_enable23, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor23 - Required23 UVM syntax23
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional23 class methods23
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual function void update_config23(apb_config23 cfg);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables23();

endclass : apb_env23

// UVM build_phase
function void apb_env23::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Create23 the APB23 UVC23 configuration class if it has not been set
  if(cfg == null) //begin
    if (!uvm_config_db#(apb_config23)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG23", "Using default_apb_config23", UVM_MEDIUM)
    $cast(cfg, factory.create_object_by_name("default_apb_config23","cfg"));
  end
  // set the master23 config
  uvm_config_object::set(this, "*", "cfg", cfg); 
  // set the slave23 configs23
  foreach(cfg.slave_configs23[i]) begin
    string sname;
    sname = $psprintf("slave23[%0d]*", i); 
    uvm_config_object::set(this, sname, "cfg", cfg.slave_configs23[i]);
  end

  bus_monitor23 = apb_monitor23::type_id::create("bus_monitor23",this);
  bus_collector23 = apb_collector23::type_id::create("bus_collector23",this);
  master23 = apb_master_agent23::type_id::create(cfg.master_config23.name,this);
  slaves23 = new[cfg.slave_configs23.size()];
  for(int i = 0; i < cfg.slave_configs23.size(); i++) begin
    slaves23[i] = apb_slave_agent23::type_id::create($psprintf("slave23[%0d]", i), this);
  end

endfunction : build_phase

// UVM connect_phase
function void apb_env23::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get23 the virtual interface if set via get_config
  if (!uvm_config_db#(virtual apb_if23)::get(this, "", "vif23", vif23))
    `uvm_error("NOVIF23",{"virtual interface must be set for: ",get_full_name(),".vif23"})
  bus_collector23.item_collected_port23.connect(bus_monitor23.coll_mon_port23);
  bus_monitor23.addr_trans_port23.connect(bus_collector23.addr_trans_export23);
  master23.monitor23 = bus_monitor23;
  master23.collector23 = bus_collector23;
  foreach(slaves23[i]) begin
    slaves23[i].monitor23 = bus_monitor23;
    slaves23[i].collector23 = bus_collector23;
    if (slaves23[i].is_active == UVM_ACTIVE)
      slaves23[i].sequencer.addr_trans_port23.connect(bus_monitor23.addr_trans_export23);
  end
endfunction : connect_phase

// UVM start_of_simulation_phase
function void apb_env23::start_of_simulation_phase(uvm_phase phase);
  set_report_id_action_hier("CFGOVR23", UVM_DISPLAY);
  set_report_id_action_hier("CFGSET23", UVM_DISPLAY);
  check_config_usage();
endfunction : start_of_simulation_phase

// update_config23() method
function void apb_env23::update_config23(apb_config23 cfg);
  bus_monitor23.cfg = cfg;
  bus_collector23.cfg = cfg;
  master23.update_config23(cfg);
  foreach(slaves23[i])
    slaves23[i].update_config23(cfg.slave_configs23[i]);
endfunction : update_config23

// update_vif_enables23
task apb_env23::update_vif_enables23();
  vif23.has_checks23 <= checks_enable23;
  vif23.has_coverage <= coverage_enable23;
  forever begin
    @(checks_enable23 || coverage_enable23);
    vif23.has_checks23 <= checks_enable23;
    vif23.has_coverage <= coverage_enable23;
  end
endtask : update_vif_enables23

//UVM run_phase()
task apb_env23::run_phase(uvm_phase phase);
  fork
    update_vif_enables23();
  join
endtask : run_phase

`endif // APB_ENV_SV23
