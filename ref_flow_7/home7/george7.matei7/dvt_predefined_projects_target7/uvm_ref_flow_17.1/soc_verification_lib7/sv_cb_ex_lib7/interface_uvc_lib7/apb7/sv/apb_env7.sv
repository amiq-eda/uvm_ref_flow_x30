/*******************************************************************************
  FILE : apb_env7.sv
*******************************************************************************/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------

`ifndef APB_ENV_SV7
`define APB_ENV_SV7

//------------------------------------------------------------------------------
// CLASS7: apb_env7
//------------------------------------------------------------------------------

class apb_env7 extends uvm_env;

  // Virtual interface for this environment7. This7 should only be done if the
  // same interface is used for all masters7/slaves7 in the environment7. Otherwise7,
  // Each agent7 should have its interface independently7 set.
  protected virtual interface apb_if7 vif7;

  // Environment7 Configuration7 Parameters7
  apb_config7 cfg;     // APB7 configuration object

  // The following7 two7 bits are used to control7 whether7 checks7 and coverage7 are
  // done both in the bus monitor7 class and the interface.
  bit checks_enable7 = 1; 
  bit coverage_enable7 = 1;

  // Components of the environment7
  apb_monitor7 bus_monitor7;
  apb_collector7 bus_collector7;
  apb_master_agent7 master7;
  apb_slave_agent7 slaves7[];

  // Provide7 implementations7 of virtual methods7 such7 as get_type_name and create
  `uvm_component_utils_begin(apb_env7)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable7, UVM_DEFAULT)
    `uvm_field_int(coverage_enable7, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor7 - Required7 UVM syntax7
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional7 class methods7
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual function void update_config7(apb_config7 cfg);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables7();

endclass : apb_env7

// UVM build_phase
function void apb_env7::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Create7 the APB7 UVC7 configuration class if it has not been set
  if(cfg == null) //begin
    if (!uvm_config_db#(apb_config7)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG7", "Using default_apb_config7", UVM_MEDIUM)
    $cast(cfg, factory.create_object_by_name("default_apb_config7","cfg"));
  end
  // set the master7 config
  uvm_config_object::set(this, "*", "cfg", cfg); 
  // set the slave7 configs7
  foreach(cfg.slave_configs7[i]) begin
    string sname;
    sname = $psprintf("slave7[%0d]*", i); 
    uvm_config_object::set(this, sname, "cfg", cfg.slave_configs7[i]);
  end

  bus_monitor7 = apb_monitor7::type_id::create("bus_monitor7",this);
  bus_collector7 = apb_collector7::type_id::create("bus_collector7",this);
  master7 = apb_master_agent7::type_id::create(cfg.master_config7.name,this);
  slaves7 = new[cfg.slave_configs7.size()];
  for(int i = 0; i < cfg.slave_configs7.size(); i++) begin
    slaves7[i] = apb_slave_agent7::type_id::create($psprintf("slave7[%0d]", i), this);
  end

endfunction : build_phase

// UVM connect_phase
function void apb_env7::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get7 the virtual interface if set via get_config
  if (!uvm_config_db#(virtual apb_if7)::get(this, "", "vif7", vif7))
    `uvm_error("NOVIF7",{"virtual interface must be set for: ",get_full_name(),".vif7"})
  bus_collector7.item_collected_port7.connect(bus_monitor7.coll_mon_port7);
  bus_monitor7.addr_trans_port7.connect(bus_collector7.addr_trans_export7);
  master7.monitor7 = bus_monitor7;
  master7.collector7 = bus_collector7;
  foreach(slaves7[i]) begin
    slaves7[i].monitor7 = bus_monitor7;
    slaves7[i].collector7 = bus_collector7;
    if (slaves7[i].is_active == UVM_ACTIVE)
      slaves7[i].sequencer.addr_trans_port7.connect(bus_monitor7.addr_trans_export7);
  end
endfunction : connect_phase

// UVM start_of_simulation_phase
function void apb_env7::start_of_simulation_phase(uvm_phase phase);
  set_report_id_action_hier("CFGOVR7", UVM_DISPLAY);
  set_report_id_action_hier("CFGSET7", UVM_DISPLAY);
  check_config_usage();
endfunction : start_of_simulation_phase

// update_config7() method
function void apb_env7::update_config7(apb_config7 cfg);
  bus_monitor7.cfg = cfg;
  bus_collector7.cfg = cfg;
  master7.update_config7(cfg);
  foreach(slaves7[i])
    slaves7[i].update_config7(cfg.slave_configs7[i]);
endfunction : update_config7

// update_vif_enables7
task apb_env7::update_vif_enables7();
  vif7.has_checks7 <= checks_enable7;
  vif7.has_coverage <= coverage_enable7;
  forever begin
    @(checks_enable7 || coverage_enable7);
    vif7.has_checks7 <= checks_enable7;
    vif7.has_coverage <= coverage_enable7;
  end
endtask : update_vif_enables7

//UVM run_phase()
task apb_env7::run_phase(uvm_phase phase);
  fork
    update_vif_enables7();
  join
endtask : run_phase

`endif // APB_ENV_SV7
