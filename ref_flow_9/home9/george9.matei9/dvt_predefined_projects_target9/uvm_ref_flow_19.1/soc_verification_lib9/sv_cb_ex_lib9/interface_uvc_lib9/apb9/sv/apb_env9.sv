/*******************************************************************************
  FILE : apb_env9.sv
*******************************************************************************/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------

`ifndef APB_ENV_SV9
`define APB_ENV_SV9

//------------------------------------------------------------------------------
// CLASS9: apb_env9
//------------------------------------------------------------------------------

class apb_env9 extends uvm_env;

  // Virtual interface for this environment9. This9 should only be done if the
  // same interface is used for all masters9/slaves9 in the environment9. Otherwise9,
  // Each agent9 should have its interface independently9 set.
  protected virtual interface apb_if9 vif9;

  // Environment9 Configuration9 Parameters9
  apb_config9 cfg;     // APB9 configuration object

  // The following9 two9 bits are used to control9 whether9 checks9 and coverage9 are
  // done both in the bus monitor9 class and the interface.
  bit checks_enable9 = 1; 
  bit coverage_enable9 = 1;

  // Components of the environment9
  apb_monitor9 bus_monitor9;
  apb_collector9 bus_collector9;
  apb_master_agent9 master9;
  apb_slave_agent9 slaves9[];

  // Provide9 implementations9 of virtual methods9 such9 as get_type_name and create
  `uvm_component_utils_begin(apb_env9)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable9, UVM_DEFAULT)
    `uvm_field_int(coverage_enable9, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor9 - Required9 UVM syntax9
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional9 class methods9
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual function void update_config9(apb_config9 cfg);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables9();

endclass : apb_env9

// UVM build_phase
function void apb_env9::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Create9 the APB9 UVC9 configuration class if it has not been set
  if(cfg == null) //begin
    if (!uvm_config_db#(apb_config9)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG9", "Using default_apb_config9", UVM_MEDIUM)
    $cast(cfg, factory.create_object_by_name("default_apb_config9","cfg"));
  end
  // set the master9 config
  uvm_config_object::set(this, "*", "cfg", cfg); 
  // set the slave9 configs9
  foreach(cfg.slave_configs9[i]) begin
    string sname;
    sname = $psprintf("slave9[%0d]*", i); 
    uvm_config_object::set(this, sname, "cfg", cfg.slave_configs9[i]);
  end

  bus_monitor9 = apb_monitor9::type_id::create("bus_monitor9",this);
  bus_collector9 = apb_collector9::type_id::create("bus_collector9",this);
  master9 = apb_master_agent9::type_id::create(cfg.master_config9.name,this);
  slaves9 = new[cfg.slave_configs9.size()];
  for(int i = 0; i < cfg.slave_configs9.size(); i++) begin
    slaves9[i] = apb_slave_agent9::type_id::create($psprintf("slave9[%0d]", i), this);
  end

endfunction : build_phase

// UVM connect_phase
function void apb_env9::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get9 the virtual interface if set via get_config
  if (!uvm_config_db#(virtual apb_if9)::get(this, "", "vif9", vif9))
    `uvm_error("NOVIF9",{"virtual interface must be set for: ",get_full_name(),".vif9"})
  bus_collector9.item_collected_port9.connect(bus_monitor9.coll_mon_port9);
  bus_monitor9.addr_trans_port9.connect(bus_collector9.addr_trans_export9);
  master9.monitor9 = bus_monitor9;
  master9.collector9 = bus_collector9;
  foreach(slaves9[i]) begin
    slaves9[i].monitor9 = bus_monitor9;
    slaves9[i].collector9 = bus_collector9;
    if (slaves9[i].is_active == UVM_ACTIVE)
      slaves9[i].sequencer.addr_trans_port9.connect(bus_monitor9.addr_trans_export9);
  end
endfunction : connect_phase

// UVM start_of_simulation_phase
function void apb_env9::start_of_simulation_phase(uvm_phase phase);
  set_report_id_action_hier("CFGOVR9", UVM_DISPLAY);
  set_report_id_action_hier("CFGSET9", UVM_DISPLAY);
  check_config_usage();
endfunction : start_of_simulation_phase

// update_config9() method
function void apb_env9::update_config9(apb_config9 cfg);
  bus_monitor9.cfg = cfg;
  bus_collector9.cfg = cfg;
  master9.update_config9(cfg);
  foreach(slaves9[i])
    slaves9[i].update_config9(cfg.slave_configs9[i]);
endfunction : update_config9

// update_vif_enables9
task apb_env9::update_vif_enables9();
  vif9.has_checks9 <= checks_enable9;
  vif9.has_coverage <= coverage_enable9;
  forever begin
    @(checks_enable9 || coverage_enable9);
    vif9.has_checks9 <= checks_enable9;
    vif9.has_coverage <= coverage_enable9;
  end
endtask : update_vif_enables9

//UVM run_phase()
task apb_env9::run_phase(uvm_phase phase);
  fork
    update_vif_enables9();
  join
endtask : run_phase

`endif // APB_ENV_SV9
