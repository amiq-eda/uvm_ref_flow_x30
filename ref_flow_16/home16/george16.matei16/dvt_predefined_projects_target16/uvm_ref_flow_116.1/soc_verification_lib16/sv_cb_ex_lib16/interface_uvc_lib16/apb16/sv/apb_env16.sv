/*******************************************************************************
  FILE : apb_env16.sv
*******************************************************************************/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------

`ifndef APB_ENV_SV16
`define APB_ENV_SV16

//------------------------------------------------------------------------------
// CLASS16: apb_env16
//------------------------------------------------------------------------------

class apb_env16 extends uvm_env;

  // Virtual interface for this environment16. This16 should only be done if the
  // same interface is used for all masters16/slaves16 in the environment16. Otherwise16,
  // Each agent16 should have its interface independently16 set.
  protected virtual interface apb_if16 vif16;

  // Environment16 Configuration16 Parameters16
  apb_config16 cfg;     // APB16 configuration object

  // The following16 two16 bits are used to control16 whether16 checks16 and coverage16 are
  // done both in the bus monitor16 class and the interface.
  bit checks_enable16 = 1; 
  bit coverage_enable16 = 1;

  // Components of the environment16
  apb_monitor16 bus_monitor16;
  apb_collector16 bus_collector16;
  apb_master_agent16 master16;
  apb_slave_agent16 slaves16[];

  // Provide16 implementations16 of virtual methods16 such16 as get_type_name and create
  `uvm_component_utils_begin(apb_env16)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable16, UVM_DEFAULT)
    `uvm_field_int(coverage_enable16, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor16 - Required16 UVM syntax16
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional16 class methods16
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual function void update_config16(apb_config16 cfg);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables16();

endclass : apb_env16

// UVM build_phase
function void apb_env16::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Create16 the APB16 UVC16 configuration class if it has not been set
  if(cfg == null) //begin
    if (!uvm_config_db#(apb_config16)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG16", "Using default_apb_config16", UVM_MEDIUM)
    $cast(cfg, factory.create_object_by_name("default_apb_config16","cfg"));
  end
  // set the master16 config
  uvm_config_object::set(this, "*", "cfg", cfg); 
  // set the slave16 configs16
  foreach(cfg.slave_configs16[i]) begin
    string sname;
    sname = $psprintf("slave16[%0d]*", i); 
    uvm_config_object::set(this, sname, "cfg", cfg.slave_configs16[i]);
  end

  bus_monitor16 = apb_monitor16::type_id::create("bus_monitor16",this);
  bus_collector16 = apb_collector16::type_id::create("bus_collector16",this);
  master16 = apb_master_agent16::type_id::create(cfg.master_config16.name,this);
  slaves16 = new[cfg.slave_configs16.size()];
  for(int i = 0; i < cfg.slave_configs16.size(); i++) begin
    slaves16[i] = apb_slave_agent16::type_id::create($psprintf("slave16[%0d]", i), this);
  end

endfunction : build_phase

// UVM connect_phase
function void apb_env16::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get16 the virtual interface if set via get_config
  if (!uvm_config_db#(virtual apb_if16)::get(this, "", "vif16", vif16))
    `uvm_error("NOVIF16",{"virtual interface must be set for: ",get_full_name(),".vif16"})
  bus_collector16.item_collected_port16.connect(bus_monitor16.coll_mon_port16);
  bus_monitor16.addr_trans_port16.connect(bus_collector16.addr_trans_export16);
  master16.monitor16 = bus_monitor16;
  master16.collector16 = bus_collector16;
  foreach(slaves16[i]) begin
    slaves16[i].monitor16 = bus_monitor16;
    slaves16[i].collector16 = bus_collector16;
    if (slaves16[i].is_active == UVM_ACTIVE)
      slaves16[i].sequencer.addr_trans_port16.connect(bus_monitor16.addr_trans_export16);
  end
endfunction : connect_phase

// UVM start_of_simulation_phase
function void apb_env16::start_of_simulation_phase(uvm_phase phase);
  set_report_id_action_hier("CFGOVR16", UVM_DISPLAY);
  set_report_id_action_hier("CFGSET16", UVM_DISPLAY);
  check_config_usage();
endfunction : start_of_simulation_phase

// update_config16() method
function void apb_env16::update_config16(apb_config16 cfg);
  bus_monitor16.cfg = cfg;
  bus_collector16.cfg = cfg;
  master16.update_config16(cfg);
  foreach(slaves16[i])
    slaves16[i].update_config16(cfg.slave_configs16[i]);
endfunction : update_config16

// update_vif_enables16
task apb_env16::update_vif_enables16();
  vif16.has_checks16 <= checks_enable16;
  vif16.has_coverage <= coverage_enable16;
  forever begin
    @(checks_enable16 || coverage_enable16);
    vif16.has_checks16 <= checks_enable16;
    vif16.has_coverage <= coverage_enable16;
  end
endtask : update_vif_enables16

//UVM run_phase()
task apb_env16::run_phase(uvm_phase phase);
  fork
    update_vif_enables16();
  join
endtask : run_phase

`endif // APB_ENV_SV16
