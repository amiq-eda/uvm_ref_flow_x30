/*******************************************************************************
  FILE : apb_env30.sv
*******************************************************************************/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------

`ifndef APB_ENV_SV30
`define APB_ENV_SV30

//------------------------------------------------------------------------------
// CLASS30: apb_env30
//------------------------------------------------------------------------------

class apb_env30 extends uvm_env;

  // Virtual interface for this environment30. This30 should only be done if the
  // same interface is used for all masters30/slaves30 in the environment30. Otherwise30,
  // Each agent30 should have its interface independently30 set.
  protected virtual interface apb_if30 vif30;

  // Environment30 Configuration30 Parameters30
  apb_config30 cfg;     // APB30 configuration object

  // The following30 two30 bits are used to control30 whether30 checks30 and coverage30 are
  // done both in the bus monitor30 class and the interface.
  bit checks_enable30 = 1; 
  bit coverage_enable30 = 1;

  // Components of the environment30
  apb_monitor30 bus_monitor30;
  apb_collector30 bus_collector30;
  apb_master_agent30 master30;
  apb_slave_agent30 slaves30[];

  // Provide30 implementations30 of virtual methods30 such30 as get_type_name and create
  `uvm_component_utils_begin(apb_env30)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable30, UVM_DEFAULT)
    `uvm_field_int(coverage_enable30, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor30 - Required30 UVM syntax30
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional30 class methods30
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual function void update_config30(apb_config30 cfg);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables30();

endclass : apb_env30

// UVM build_phase
function void apb_env30::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Create30 the APB30 UVC30 configuration class if it has not been set
  if(cfg == null) //begin
    if (!uvm_config_db#(apb_config30)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG30", "Using default_apb_config30", UVM_MEDIUM)
    $cast(cfg, factory.create_object_by_name("default_apb_config30","cfg"));
  end
  // set the master30 config
  uvm_config_object::set(this, "*", "cfg", cfg); 
  // set the slave30 configs30
  foreach(cfg.slave_configs30[i]) begin
    string sname;
    sname = $psprintf("slave30[%0d]*", i); 
    uvm_config_object::set(this, sname, "cfg", cfg.slave_configs30[i]);
  end

  bus_monitor30 = apb_monitor30::type_id::create("bus_monitor30",this);
  bus_collector30 = apb_collector30::type_id::create("bus_collector30",this);
  master30 = apb_master_agent30::type_id::create(cfg.master_config30.name,this);
  slaves30 = new[cfg.slave_configs30.size()];
  for(int i = 0; i < cfg.slave_configs30.size(); i++) begin
    slaves30[i] = apb_slave_agent30::type_id::create($psprintf("slave30[%0d]", i), this);
  end

endfunction : build_phase

// UVM connect_phase
function void apb_env30::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get30 the virtual interface if set via get_config
  if (!uvm_config_db#(virtual apb_if30)::get(this, "", "vif30", vif30))
    `uvm_error("NOVIF30",{"virtual interface must be set for: ",get_full_name(),".vif30"})
  bus_collector30.item_collected_port30.connect(bus_monitor30.coll_mon_port30);
  bus_monitor30.addr_trans_port30.connect(bus_collector30.addr_trans_export30);
  master30.monitor30 = bus_monitor30;
  master30.collector30 = bus_collector30;
  foreach(slaves30[i]) begin
    slaves30[i].monitor30 = bus_monitor30;
    slaves30[i].collector30 = bus_collector30;
    if (slaves30[i].is_active == UVM_ACTIVE)
      slaves30[i].sequencer.addr_trans_port30.connect(bus_monitor30.addr_trans_export30);
  end
endfunction : connect_phase

// UVM start_of_simulation_phase
function void apb_env30::start_of_simulation_phase(uvm_phase phase);
  set_report_id_action_hier("CFGOVR30", UVM_DISPLAY);
  set_report_id_action_hier("CFGSET30", UVM_DISPLAY);
  check_config_usage();
endfunction : start_of_simulation_phase

// update_config30() method
function void apb_env30::update_config30(apb_config30 cfg);
  bus_monitor30.cfg = cfg;
  bus_collector30.cfg = cfg;
  master30.update_config30(cfg);
  foreach(slaves30[i])
    slaves30[i].update_config30(cfg.slave_configs30[i]);
endfunction : update_config30

// update_vif_enables30
task apb_env30::update_vif_enables30();
  vif30.has_checks30 <= checks_enable30;
  vif30.has_coverage <= coverage_enable30;
  forever begin
    @(checks_enable30 || coverage_enable30);
    vif30.has_checks30 <= checks_enable30;
    vif30.has_coverage <= coverage_enable30;
  end
endtask : update_vif_enables30

//UVM run_phase()
task apb_env30::run_phase(uvm_phase phase);
  fork
    update_vif_enables30();
  join
endtask : run_phase

`endif // APB_ENV_SV30
