/*******************************************************************************
  FILE : apb_env14.sv
*******************************************************************************/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------

`ifndef APB_ENV_SV14
`define APB_ENV_SV14

//------------------------------------------------------------------------------
// CLASS14: apb_env14
//------------------------------------------------------------------------------

class apb_env14 extends uvm_env;

  // Virtual interface for this environment14. This14 should only be done if the
  // same interface is used for all masters14/slaves14 in the environment14. Otherwise14,
  // Each agent14 should have its interface independently14 set.
  protected virtual interface apb_if14 vif14;

  // Environment14 Configuration14 Parameters14
  apb_config14 cfg;     // APB14 configuration object

  // The following14 two14 bits are used to control14 whether14 checks14 and coverage14 are
  // done both in the bus monitor14 class and the interface.
  bit checks_enable14 = 1; 
  bit coverage_enable14 = 1;

  // Components of the environment14
  apb_monitor14 bus_monitor14;
  apb_collector14 bus_collector14;
  apb_master_agent14 master14;
  apb_slave_agent14 slaves14[];

  // Provide14 implementations14 of virtual methods14 such14 as get_type_name and create
  `uvm_component_utils_begin(apb_env14)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable14, UVM_DEFAULT)
    `uvm_field_int(coverage_enable14, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor14 - Required14 UVM syntax14
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional14 class methods14
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual function void update_config14(apb_config14 cfg);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables14();

endclass : apb_env14

// UVM build_phase
function void apb_env14::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Create14 the APB14 UVC14 configuration class if it has not been set
  if(cfg == null) //begin
    if (!uvm_config_db#(apb_config14)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG14", "Using default_apb_config14", UVM_MEDIUM)
    $cast(cfg, factory.create_object_by_name("default_apb_config14","cfg"));
  end
  // set the master14 config
  uvm_config_object::set(this, "*", "cfg", cfg); 
  // set the slave14 configs14
  foreach(cfg.slave_configs14[i]) begin
    string sname;
    sname = $psprintf("slave14[%0d]*", i); 
    uvm_config_object::set(this, sname, "cfg", cfg.slave_configs14[i]);
  end

  bus_monitor14 = apb_monitor14::type_id::create("bus_monitor14",this);
  bus_collector14 = apb_collector14::type_id::create("bus_collector14",this);
  master14 = apb_master_agent14::type_id::create(cfg.master_config14.name,this);
  slaves14 = new[cfg.slave_configs14.size()];
  for(int i = 0; i < cfg.slave_configs14.size(); i++) begin
    slaves14[i] = apb_slave_agent14::type_id::create($psprintf("slave14[%0d]", i), this);
  end

endfunction : build_phase

// UVM connect_phase
function void apb_env14::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get14 the virtual interface if set via get_config
  if (!uvm_config_db#(virtual apb_if14)::get(this, "", "vif14", vif14))
    `uvm_error("NOVIF14",{"virtual interface must be set for: ",get_full_name(),".vif14"})
  bus_collector14.item_collected_port14.connect(bus_monitor14.coll_mon_port14);
  bus_monitor14.addr_trans_port14.connect(bus_collector14.addr_trans_export14);
  master14.monitor14 = bus_monitor14;
  master14.collector14 = bus_collector14;
  foreach(slaves14[i]) begin
    slaves14[i].monitor14 = bus_monitor14;
    slaves14[i].collector14 = bus_collector14;
    if (slaves14[i].is_active == UVM_ACTIVE)
      slaves14[i].sequencer.addr_trans_port14.connect(bus_monitor14.addr_trans_export14);
  end
endfunction : connect_phase

// UVM start_of_simulation_phase
function void apb_env14::start_of_simulation_phase(uvm_phase phase);
  set_report_id_action_hier("CFGOVR14", UVM_DISPLAY);
  set_report_id_action_hier("CFGSET14", UVM_DISPLAY);
  check_config_usage();
endfunction : start_of_simulation_phase

// update_config14() method
function void apb_env14::update_config14(apb_config14 cfg);
  bus_monitor14.cfg = cfg;
  bus_collector14.cfg = cfg;
  master14.update_config14(cfg);
  foreach(slaves14[i])
    slaves14[i].update_config14(cfg.slave_configs14[i]);
endfunction : update_config14

// update_vif_enables14
task apb_env14::update_vif_enables14();
  vif14.has_checks14 <= checks_enable14;
  vif14.has_coverage <= coverage_enable14;
  forever begin
    @(checks_enable14 || coverage_enable14);
    vif14.has_checks14 <= checks_enable14;
    vif14.has_coverage <= coverage_enable14;
  end
endtask : update_vif_enables14

//UVM run_phase()
task apb_env14::run_phase(uvm_phase phase);
  fork
    update_vif_enables14();
  join
endtask : run_phase

`endif // APB_ENV_SV14
