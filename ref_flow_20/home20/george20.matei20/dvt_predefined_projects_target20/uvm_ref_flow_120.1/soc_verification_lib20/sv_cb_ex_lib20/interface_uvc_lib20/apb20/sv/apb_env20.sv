/*******************************************************************************
  FILE : apb_env20.sv
*******************************************************************************/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------

`ifndef APB_ENV_SV20
`define APB_ENV_SV20

//------------------------------------------------------------------------------
// CLASS20: apb_env20
//------------------------------------------------------------------------------

class apb_env20 extends uvm_env;

  // Virtual interface for this environment20. This20 should only be done if the
  // same interface is used for all masters20/slaves20 in the environment20. Otherwise20,
  // Each agent20 should have its interface independently20 set.
  protected virtual interface apb_if20 vif20;

  // Environment20 Configuration20 Parameters20
  apb_config20 cfg;     // APB20 configuration object

  // The following20 two20 bits are used to control20 whether20 checks20 and coverage20 are
  // done both in the bus monitor20 class and the interface.
  bit checks_enable20 = 1; 
  bit coverage_enable20 = 1;

  // Components of the environment20
  apb_monitor20 bus_monitor20;
  apb_collector20 bus_collector20;
  apb_master_agent20 master20;
  apb_slave_agent20 slaves20[];

  // Provide20 implementations20 of virtual methods20 such20 as get_type_name and create
  `uvm_component_utils_begin(apb_env20)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable20, UVM_DEFAULT)
    `uvm_field_int(coverage_enable20, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor20 - Required20 UVM syntax20
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional20 class methods20
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual function void update_config20(apb_config20 cfg);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables20();

endclass : apb_env20

// UVM build_phase
function void apb_env20::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Create20 the APB20 UVC20 configuration class if it has not been set
  if(cfg == null) //begin
    if (!uvm_config_db#(apb_config20)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG20", "Using default_apb_config20", UVM_MEDIUM)
    $cast(cfg, factory.create_object_by_name("default_apb_config20","cfg"));
  end
  // set the master20 config
  uvm_config_object::set(this, "*", "cfg", cfg); 
  // set the slave20 configs20
  foreach(cfg.slave_configs20[i]) begin
    string sname;
    sname = $psprintf("slave20[%0d]*", i); 
    uvm_config_object::set(this, sname, "cfg", cfg.slave_configs20[i]);
  end

  bus_monitor20 = apb_monitor20::type_id::create("bus_monitor20",this);
  bus_collector20 = apb_collector20::type_id::create("bus_collector20",this);
  master20 = apb_master_agent20::type_id::create(cfg.master_config20.name,this);
  slaves20 = new[cfg.slave_configs20.size()];
  for(int i = 0; i < cfg.slave_configs20.size(); i++) begin
    slaves20[i] = apb_slave_agent20::type_id::create($psprintf("slave20[%0d]", i), this);
  end

endfunction : build_phase

// UVM connect_phase
function void apb_env20::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get20 the virtual interface if set via get_config
  if (!uvm_config_db#(virtual apb_if20)::get(this, "", "vif20", vif20))
    `uvm_error("NOVIF20",{"virtual interface must be set for: ",get_full_name(),".vif20"})
  bus_collector20.item_collected_port20.connect(bus_monitor20.coll_mon_port20);
  bus_monitor20.addr_trans_port20.connect(bus_collector20.addr_trans_export20);
  master20.monitor20 = bus_monitor20;
  master20.collector20 = bus_collector20;
  foreach(slaves20[i]) begin
    slaves20[i].monitor20 = bus_monitor20;
    slaves20[i].collector20 = bus_collector20;
    if (slaves20[i].is_active == UVM_ACTIVE)
      slaves20[i].sequencer.addr_trans_port20.connect(bus_monitor20.addr_trans_export20);
  end
endfunction : connect_phase

// UVM start_of_simulation_phase
function void apb_env20::start_of_simulation_phase(uvm_phase phase);
  set_report_id_action_hier("CFGOVR20", UVM_DISPLAY);
  set_report_id_action_hier("CFGSET20", UVM_DISPLAY);
  check_config_usage();
endfunction : start_of_simulation_phase

// update_config20() method
function void apb_env20::update_config20(apb_config20 cfg);
  bus_monitor20.cfg = cfg;
  bus_collector20.cfg = cfg;
  master20.update_config20(cfg);
  foreach(slaves20[i])
    slaves20[i].update_config20(cfg.slave_configs20[i]);
endfunction : update_config20

// update_vif_enables20
task apb_env20::update_vif_enables20();
  vif20.has_checks20 <= checks_enable20;
  vif20.has_coverage <= coverage_enable20;
  forever begin
    @(checks_enable20 || coverage_enable20);
    vif20.has_checks20 <= checks_enable20;
    vif20.has_coverage <= coverage_enable20;
  end
endtask : update_vif_enables20

//UVM run_phase()
task apb_env20::run_phase(uvm_phase phase);
  fork
    update_vif_enables20();
  join
endtask : run_phase

`endif // APB_ENV_SV20
