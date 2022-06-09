/*******************************************************************************
  FILE : apb_env4.sv
*******************************************************************************/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------

`ifndef APB_ENV_SV4
`define APB_ENV_SV4

//------------------------------------------------------------------------------
// CLASS4: apb_env4
//------------------------------------------------------------------------------

class apb_env4 extends uvm_env;

  // Virtual interface for this environment4. This4 should only be done if the
  // same interface is used for all masters4/slaves4 in the environment4. Otherwise4,
  // Each agent4 should have its interface independently4 set.
  protected virtual interface apb_if4 vif4;

  // Environment4 Configuration4 Parameters4
  apb_config4 cfg;     // APB4 configuration object

  // The following4 two4 bits are used to control4 whether4 checks4 and coverage4 are
  // done both in the bus monitor4 class and the interface.
  bit checks_enable4 = 1; 
  bit coverage_enable4 = 1;

  // Components of the environment4
  apb_monitor4 bus_monitor4;
  apb_collector4 bus_collector4;
  apb_master_agent4 master4;
  apb_slave_agent4 slaves4[];

  // Provide4 implementations4 of virtual methods4 such4 as get_type_name and create
  `uvm_component_utils_begin(apb_env4)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable4, UVM_DEFAULT)
    `uvm_field_int(coverage_enable4, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor4 - Required4 UVM syntax4
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional4 class methods4
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual function void update_config4(apb_config4 cfg);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables4();

endclass : apb_env4

// UVM build_phase
function void apb_env4::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Create4 the APB4 UVC4 configuration class if it has not been set
  if(cfg == null) //begin
    if (!uvm_config_db#(apb_config4)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG4", "Using default_apb_config4", UVM_MEDIUM)
    $cast(cfg, factory.create_object_by_name("default_apb_config4","cfg"));
  end
  // set the master4 config
  uvm_config_object::set(this, "*", "cfg", cfg); 
  // set the slave4 configs4
  foreach(cfg.slave_configs4[i]) begin
    string sname;
    sname = $psprintf("slave4[%0d]*", i); 
    uvm_config_object::set(this, sname, "cfg", cfg.slave_configs4[i]);
  end

  bus_monitor4 = apb_monitor4::type_id::create("bus_monitor4",this);
  bus_collector4 = apb_collector4::type_id::create("bus_collector4",this);
  master4 = apb_master_agent4::type_id::create(cfg.master_config4.name,this);
  slaves4 = new[cfg.slave_configs4.size()];
  for(int i = 0; i < cfg.slave_configs4.size(); i++) begin
    slaves4[i] = apb_slave_agent4::type_id::create($psprintf("slave4[%0d]", i), this);
  end

endfunction : build_phase

// UVM connect_phase
function void apb_env4::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get4 the virtual interface if set via get_config
  if (!uvm_config_db#(virtual apb_if4)::get(this, "", "vif4", vif4))
    `uvm_error("NOVIF4",{"virtual interface must be set for: ",get_full_name(),".vif4"})
  bus_collector4.item_collected_port4.connect(bus_monitor4.coll_mon_port4);
  bus_monitor4.addr_trans_port4.connect(bus_collector4.addr_trans_export4);
  master4.monitor4 = bus_monitor4;
  master4.collector4 = bus_collector4;
  foreach(slaves4[i]) begin
    slaves4[i].monitor4 = bus_monitor4;
    slaves4[i].collector4 = bus_collector4;
    if (slaves4[i].is_active == UVM_ACTIVE)
      slaves4[i].sequencer.addr_trans_port4.connect(bus_monitor4.addr_trans_export4);
  end
endfunction : connect_phase

// UVM start_of_simulation_phase
function void apb_env4::start_of_simulation_phase(uvm_phase phase);
  set_report_id_action_hier("CFGOVR4", UVM_DISPLAY);
  set_report_id_action_hier("CFGSET4", UVM_DISPLAY);
  check_config_usage();
endfunction : start_of_simulation_phase

// update_config4() method
function void apb_env4::update_config4(apb_config4 cfg);
  bus_monitor4.cfg = cfg;
  bus_collector4.cfg = cfg;
  master4.update_config4(cfg);
  foreach(slaves4[i])
    slaves4[i].update_config4(cfg.slave_configs4[i]);
endfunction : update_config4

// update_vif_enables4
task apb_env4::update_vif_enables4();
  vif4.has_checks4 <= checks_enable4;
  vif4.has_coverage <= coverage_enable4;
  forever begin
    @(checks_enable4 || coverage_enable4);
    vif4.has_checks4 <= checks_enable4;
    vif4.has_coverage <= coverage_enable4;
  end
endtask : update_vif_enables4

//UVM run_phase()
task apb_env4::run_phase(uvm_phase phase);
  fork
    update_vif_enables4();
  join
endtask : run_phase

`endif // APB_ENV_SV4
