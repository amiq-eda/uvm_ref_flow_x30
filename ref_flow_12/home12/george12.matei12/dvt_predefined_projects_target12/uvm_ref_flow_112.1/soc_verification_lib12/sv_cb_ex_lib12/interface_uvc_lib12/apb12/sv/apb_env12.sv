/*******************************************************************************
  FILE : apb_env12.sv
*******************************************************************************/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------

`ifndef APB_ENV_SV12
`define APB_ENV_SV12

//------------------------------------------------------------------------------
// CLASS12: apb_env12
//------------------------------------------------------------------------------

class apb_env12 extends uvm_env;

  // Virtual interface for this environment12. This12 should only be done if the
  // same interface is used for all masters12/slaves12 in the environment12. Otherwise12,
  // Each agent12 should have its interface independently12 set.
  protected virtual interface apb_if12 vif12;

  // Environment12 Configuration12 Parameters12
  apb_config12 cfg;     // APB12 configuration object

  // The following12 two12 bits are used to control12 whether12 checks12 and coverage12 are
  // done both in the bus monitor12 class and the interface.
  bit checks_enable12 = 1; 
  bit coverage_enable12 = 1;

  // Components of the environment12
  apb_monitor12 bus_monitor12;
  apb_collector12 bus_collector12;
  apb_master_agent12 master12;
  apb_slave_agent12 slaves12[];

  // Provide12 implementations12 of virtual methods12 such12 as get_type_name and create
  `uvm_component_utils_begin(apb_env12)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable12, UVM_DEFAULT)
    `uvm_field_int(coverage_enable12, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor12 - Required12 UVM syntax12
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional12 class methods12
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual function void update_config12(apb_config12 cfg);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables12();

endclass : apb_env12

// UVM build_phase
function void apb_env12::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Create12 the APB12 UVC12 configuration class if it has not been set
  if(cfg == null) //begin
    if (!uvm_config_db#(apb_config12)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG12", "Using default_apb_config12", UVM_MEDIUM)
    $cast(cfg, factory.create_object_by_name("default_apb_config12","cfg"));
  end
  // set the master12 config
  uvm_config_object::set(this, "*", "cfg", cfg); 
  // set the slave12 configs12
  foreach(cfg.slave_configs12[i]) begin
    string sname;
    sname = $psprintf("slave12[%0d]*", i); 
    uvm_config_object::set(this, sname, "cfg", cfg.slave_configs12[i]);
  end

  bus_monitor12 = apb_monitor12::type_id::create("bus_monitor12",this);
  bus_collector12 = apb_collector12::type_id::create("bus_collector12",this);
  master12 = apb_master_agent12::type_id::create(cfg.master_config12.name,this);
  slaves12 = new[cfg.slave_configs12.size()];
  for(int i = 0; i < cfg.slave_configs12.size(); i++) begin
    slaves12[i] = apb_slave_agent12::type_id::create($psprintf("slave12[%0d]", i), this);
  end

endfunction : build_phase

// UVM connect_phase
function void apb_env12::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get12 the virtual interface if set via get_config
  if (!uvm_config_db#(virtual apb_if12)::get(this, "", "vif12", vif12))
    `uvm_error("NOVIF12",{"virtual interface must be set for: ",get_full_name(),".vif12"})
  bus_collector12.item_collected_port12.connect(bus_monitor12.coll_mon_port12);
  bus_monitor12.addr_trans_port12.connect(bus_collector12.addr_trans_export12);
  master12.monitor12 = bus_monitor12;
  master12.collector12 = bus_collector12;
  foreach(slaves12[i]) begin
    slaves12[i].monitor12 = bus_monitor12;
    slaves12[i].collector12 = bus_collector12;
    if (slaves12[i].is_active == UVM_ACTIVE)
      slaves12[i].sequencer.addr_trans_port12.connect(bus_monitor12.addr_trans_export12);
  end
endfunction : connect_phase

// UVM start_of_simulation_phase
function void apb_env12::start_of_simulation_phase(uvm_phase phase);
  set_report_id_action_hier("CFGOVR12", UVM_DISPLAY);
  set_report_id_action_hier("CFGSET12", UVM_DISPLAY);
  check_config_usage();
endfunction : start_of_simulation_phase

// update_config12() method
function void apb_env12::update_config12(apb_config12 cfg);
  bus_monitor12.cfg = cfg;
  bus_collector12.cfg = cfg;
  master12.update_config12(cfg);
  foreach(slaves12[i])
    slaves12[i].update_config12(cfg.slave_configs12[i]);
endfunction : update_config12

// update_vif_enables12
task apb_env12::update_vif_enables12();
  vif12.has_checks12 <= checks_enable12;
  vif12.has_coverage <= coverage_enable12;
  forever begin
    @(checks_enable12 || coverage_enable12);
    vif12.has_checks12 <= checks_enable12;
    vif12.has_coverage <= coverage_enable12;
  end
endtask : update_vif_enables12

//UVM run_phase()
task apb_env12::run_phase(uvm_phase phase);
  fork
    update_vif_enables12();
  join
endtask : run_phase

`endif // APB_ENV_SV12
