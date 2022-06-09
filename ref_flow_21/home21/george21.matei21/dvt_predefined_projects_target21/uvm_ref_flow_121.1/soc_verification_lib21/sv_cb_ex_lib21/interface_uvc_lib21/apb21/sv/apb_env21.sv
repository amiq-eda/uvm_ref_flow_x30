/*******************************************************************************
  FILE : apb_env21.sv
*******************************************************************************/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------

`ifndef APB_ENV_SV21
`define APB_ENV_SV21

//------------------------------------------------------------------------------
// CLASS21: apb_env21
//------------------------------------------------------------------------------

class apb_env21 extends uvm_env;

  // Virtual interface for this environment21. This21 should only be done if the
  // same interface is used for all masters21/slaves21 in the environment21. Otherwise21,
  // Each agent21 should have its interface independently21 set.
  protected virtual interface apb_if21 vif21;

  // Environment21 Configuration21 Parameters21
  apb_config21 cfg;     // APB21 configuration object

  // The following21 two21 bits are used to control21 whether21 checks21 and coverage21 are
  // done both in the bus monitor21 class and the interface.
  bit checks_enable21 = 1; 
  bit coverage_enable21 = 1;

  // Components of the environment21
  apb_monitor21 bus_monitor21;
  apb_collector21 bus_collector21;
  apb_master_agent21 master21;
  apb_slave_agent21 slaves21[];

  // Provide21 implementations21 of virtual methods21 such21 as get_type_name and create
  `uvm_component_utils_begin(apb_env21)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable21, UVM_DEFAULT)
    `uvm_field_int(coverage_enable21, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor21 - Required21 UVM syntax21
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional21 class methods21
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual function void update_config21(apb_config21 cfg);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables21();

endclass : apb_env21

// UVM build_phase
function void apb_env21::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Create21 the APB21 UVC21 configuration class if it has not been set
  if(cfg == null) //begin
    if (!uvm_config_db#(apb_config21)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG21", "Using default_apb_config21", UVM_MEDIUM)
    $cast(cfg, factory.create_object_by_name("default_apb_config21","cfg"));
  end
  // set the master21 config
  uvm_config_object::set(this, "*", "cfg", cfg); 
  // set the slave21 configs21
  foreach(cfg.slave_configs21[i]) begin
    string sname;
    sname = $psprintf("slave21[%0d]*", i); 
    uvm_config_object::set(this, sname, "cfg", cfg.slave_configs21[i]);
  end

  bus_monitor21 = apb_monitor21::type_id::create("bus_monitor21",this);
  bus_collector21 = apb_collector21::type_id::create("bus_collector21",this);
  master21 = apb_master_agent21::type_id::create(cfg.master_config21.name,this);
  slaves21 = new[cfg.slave_configs21.size()];
  for(int i = 0; i < cfg.slave_configs21.size(); i++) begin
    slaves21[i] = apb_slave_agent21::type_id::create($psprintf("slave21[%0d]", i), this);
  end

endfunction : build_phase

// UVM connect_phase
function void apb_env21::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get21 the virtual interface if set via get_config
  if (!uvm_config_db#(virtual apb_if21)::get(this, "", "vif21", vif21))
    `uvm_error("NOVIF21",{"virtual interface must be set for: ",get_full_name(),".vif21"})
  bus_collector21.item_collected_port21.connect(bus_monitor21.coll_mon_port21);
  bus_monitor21.addr_trans_port21.connect(bus_collector21.addr_trans_export21);
  master21.monitor21 = bus_monitor21;
  master21.collector21 = bus_collector21;
  foreach(slaves21[i]) begin
    slaves21[i].monitor21 = bus_monitor21;
    slaves21[i].collector21 = bus_collector21;
    if (slaves21[i].is_active == UVM_ACTIVE)
      slaves21[i].sequencer.addr_trans_port21.connect(bus_monitor21.addr_trans_export21);
  end
endfunction : connect_phase

// UVM start_of_simulation_phase
function void apb_env21::start_of_simulation_phase(uvm_phase phase);
  set_report_id_action_hier("CFGOVR21", UVM_DISPLAY);
  set_report_id_action_hier("CFGSET21", UVM_DISPLAY);
  check_config_usage();
endfunction : start_of_simulation_phase

// update_config21() method
function void apb_env21::update_config21(apb_config21 cfg);
  bus_monitor21.cfg = cfg;
  bus_collector21.cfg = cfg;
  master21.update_config21(cfg);
  foreach(slaves21[i])
    slaves21[i].update_config21(cfg.slave_configs21[i]);
endfunction : update_config21

// update_vif_enables21
task apb_env21::update_vif_enables21();
  vif21.has_checks21 <= checks_enable21;
  vif21.has_coverage <= coverage_enable21;
  forever begin
    @(checks_enable21 || coverage_enable21);
    vif21.has_checks21 <= checks_enable21;
    vif21.has_coverage <= coverage_enable21;
  end
endtask : update_vif_enables21

//UVM run_phase()
task apb_env21::run_phase(uvm_phase phase);
  fork
    update_vif_enables21();
  join
endtask : run_phase

`endif // APB_ENV_SV21
